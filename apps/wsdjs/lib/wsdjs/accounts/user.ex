defmodule Wsdjs.Accounts.User do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Wsdjs.Accounts.User

  alias Wsdjs.{Musics, Accounts, Charts, Reactions, Auth}
  alias Wsdjs.Accounts.{UserParameter, UserDetail}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :admin, :boolean
    field :user_country, :string
    field :name, :string
    field :djname, :string
    field :profil_djvip, :boolean
    field :profil_dj, :boolean
    field :deactivated, :boolean
    field :activated_at, :naive_datetime

    has_many :songs, Musics.Song
    has_many :comments, Reactions.Comment
    has_one :avatar, Accounts.Avatar, on_replace: :delete
    has_one :detail, Accounts.UserDetail, on_replace: :update
    has_one :parameter, Accounts.UserParameter, on_replace: :update
    has_many :song_opinions, Reactions.Opinion
    has_many :votes, Charts.Vote
    has_many :auth_tokens, Auth.AuthToken

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:user_country, :name, :djname])
    |> cast_assoc(:avatar)
    |> cast_assoc(:detail)
    |> cast_assoc(:parameter, with: &Accounts.UserParameter.changeset/2)
  end

  def admin_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:user_country, :name, :djname, :admin, :profil_djvip, :profil_dj, :deactivated])
    |> cast_assoc(:avatar)
    |> cast_assoc(:detail)
    |> cast_assoc(:parameter, with: &Accounts.UserParameter.admin_changeset/2)
  end

  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required(:email)
    |> downcase_value()
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
    |> put_assoc(:parameter, UserParameter.changeset(%UserParameter{}, %{}), required: true)
    |> put_assoc(:detail, UserDetail.changeset(%UserDetail{}, %{}), required: true)
  end

  defp downcase_value(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end

  @doc """
  The function scope is used to filter the users according to the user specified.
  - Admin see every user
  - Connected user can every users exceptsee himself and not admin users
  - Not connected users see nothing
  """
  def scoped(%Accounts.User{admin: true}), do: Accounts.User
  def scoped(%Accounts.User{} = user) do
    from u in Accounts.User, where: u.id == ^user.id or u.admin == false
  end
  def scoped(nil), do: from u in Accounts.User, where: u.admin == false
end

defimpl Bamboo.Formatter, for: Wsdjs.Accounts.User do
  def format_email_address(user, _opts) do
    {user.name, user.email}
  end
end
