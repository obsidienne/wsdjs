defmodule Brididi.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Brididi.Accounts
  alias Brididi.Accounts.UserProfil
  alias Brididi.Charts
  alias Brididi.Reactions.{Comments, Opinions}

  @derive {Inspect, except: [:password]}
  @primary_key {:id, Brididi.HashID, autogenerate: true}
  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:hashed_password, :string)
    field(:admin, :boolean, default: false)
    field(:profil_djvip, :boolean, default: false)
    field(:profil_dj, :boolean, default: false)
    field(:confirmed_at, :naive_datetime)

    has_many(:songs, Brididi.Musics.Song)
    has_many(:comments, Comments.Comment)
    has_one(:user_profil, Accounts.UserProfil, on_replace: :update)
    has_many(:song_opinions, Opinions.Opinion)
    has_many(:votes, Charts.Vote)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:user_country, :name, :djname])
    |> cast_assoc(:user_profil)
  end

  def admin_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :admin,
      :profil_djvip,
      :profil_dj
    ])
    |> cast_assoc(:user_profil)
  end

  def create_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required(:email)
    |> downcase_value()
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
    |> put_assoc(:user_profil, UserProfil.changeset(%UserProfil{}, %{}), required: true)
  end

  defp downcase_value(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.
  """
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_email()
    |> validate_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Brididi.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> prepare_changes(&hash_password/1)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:hashed_password, Argon2.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.
  """
  def password_changeset(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password()
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Argon2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Brididi.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Argon2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end

defimpl Bamboo.Formatter, for: Brididi.Accounts.User do
  def format_email_address(user, _opts) do
    {user.name, user.email}
  end
end
