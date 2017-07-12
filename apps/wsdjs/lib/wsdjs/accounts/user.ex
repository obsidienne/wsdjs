defmodule Wsdjs.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Wsdjs.{Musics, Accounts, Trendings}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :admin, :boolean
    field :new_song_notification, :boolean
    field :user_country, :string
    field :name, :string
    field :djname, :string
    field :description, :string

    has_many :songs, Musics.Song
    has_many :comments, Musics.Comment
    has_one :avatar, Accounts.Avatar, on_replace: :delete
    has_many :song_opinions, Musics.Opinion
    has_many :votes, Trendings.Vote
    has_many :auth_tokens, Accounts.AuthToken

    timestamps()
  end

  @allowed_fields [:email, :new_song_notification, :user_country, :name, :djname, :description]

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(:email)
    |> cast_assoc(:avatar)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
  end

  @doc """
  The function scope is used to filter the users according to the user specified.
  - Admin see every user
  - Connected user can see himself and not admin users
  - Not connected users see nothing
  """
  def scoped(%Accounts.User{admin: :true}), do: Accounts.User
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