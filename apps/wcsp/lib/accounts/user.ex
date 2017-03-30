defmodule Wcsp.Accounts.User do
  use Wcsp.Schema

  alias Wcsp.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
#  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :admin, :boolean
    field :new_song_notification, :boolean
    field :user_country, :string
    field :name, :string
    field :djname, :string

    has_many :songs, Wcsp.Musics.Song
    has_many :comments, Wcsp.Musics.Comment
    has_one :avatar, Wcsp.Accounts.Avatar
    has_many :song_opinions, Wcsp.Musics.Opinion
    has_many :rank_songs, Wcsp.RankSong

    timestamps()
  end

  @allowed_fields [:email, :new_song_notification, :user_country, :name, :djname]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(:email)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
  end

  def build(%{email: _} = params) do
    changeset(%User{}, params)
  end


  @doc """
  Admin see every user
  """
  def scoped(%User{admin: :true}), do: User

  @doc """
  Connected user can see himself and not admin users
  """
  def scoped(%User{} = user) do
    from u in User, where: u.id == ^user.id or u.admin == false
  end

  @doc """
  Not connected users see nothing
  """
  def scoped(nil) do
    from u in User, where: u.admin == false
  end

  @doc """
  Preload user avatar using a join
  """
  def with_avatar(query) do
    from q in query,
    preload: :avatar
  end

  def with_songs(query, current_user) do
    preload_query = from s in Wcsp.Musics.Song.scoped(current_user), order_by: [desc: :inserted_at]

    from p in query,
    preload: [songs: ^preload_query],
    preload: [songs: :album_art]
  end
end
