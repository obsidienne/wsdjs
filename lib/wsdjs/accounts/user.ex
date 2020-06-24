defmodule Wsdjs.Accounts.User do
  @moduledoc false
  use Wsdjs.Schema
  import Ecto.Changeset

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.Profil
  alias Wsdjs.Attachments
  alias Wsdjs.Auth
  alias Wsdjs.Charts
  alias Wsdjs.Musics
  alias Wsdjs.Reactions.{Comments, Opinions}

  schema "users" do
    field(:email, :string)
    field(:admin, :boolean, default: false)
    field(:user_country, :string)
    field(:name, :string)
    field(:djname, :string)
    field(:profil_djvip, :boolean, default: false)
    field(:profil_dj, :boolean, default: false)
    field(:deactivated, :boolean, default: false)
    field(:confirmed_at, :naive_datetime)
    field(:verified_profil, :boolean, default: false)

    has_many(:songs, Musics.Song)
    has_many(:comments, Comments.Comment)
    has_one(:avatar, Attachments.Avatars.Avatar, on_replace: :delete)
    has_one(:profil, Accounts.Profil, on_replace: :update)
    has_many(:song_opinions, Opinions.Opinion)
    has_many(:votes, Charts.Vote)
    has_many(:auth_tokens, Auth.AuthToken)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:user_country, :name, :djname])
    |> cast_assoc(:avatar)
    |> cast_assoc(:profil)
  end

  def admin_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [
      :email,
      :user_country,
      :name,
      :djname,
      :admin,
      :profil_djvip,
      :profil_dj,
      :deactivated,
      :verified_profil
    ])
    |> cast_assoc(:avatar)
    |> cast_assoc(:profil)
  end

  def create_changeset(%__MODULE__{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required(:email)
    |> downcase_value()
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
    |> put_assoc(:profil, Profil.changeset(%Profil{}, %{}), required: true)
  end

  defp downcase_value(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end
end

defimpl Bamboo.Formatter, for: Wsdjs.Accounts.User do
  def format_email_address(user, _opts) do
    {user.name, user.email}
  end
end
