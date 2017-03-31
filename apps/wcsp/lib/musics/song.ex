defmodule Wcsp.Musics.Song do
  use Wcsp.Schema

  alias Wcsp.Trendings
  alias Wcsp.Accounts
  alias Wcsp.Musics

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "songs" do
    field :title, :string
    field :artist, :string
    field :url, :string
    field :bpm, :integer
    field :genre, :string

    belongs_to :user, Accounts.User
    has_one :album_art, Musics.Art
    has_many :comments, Musics.Comment
    has_many :ranks, Trendings.Rank
    has_many :opinions, Musics.Opinion
    has_many :rank_songs, Trendings.Vote
    many_to_many :tops, Trendings.Top, join_through: Trendings.Rank

    timestamps()
  end

  @allowed_fields [:title, :artist, :url, :bpm, :genre, :user_id]
  @required_fields [:title, :artist, :url, :genre]
  @validated_genre ~w(acoustic blues country dance hiphop jazz pop rnb rock soul)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:title, name: :songs_title_artist_index)
    |> assoc_constraint(:user)
    |> validate_number(:bpm, greater_than: 0)
    |> validate_inclusion(:genre, @validated_genre)
    |> validate_url(:url)
  end

  def genre, do: @validated_genre


  @doc """
  Admin sees everything
  """
  def scoped(%Accounts.User{admin: :true}), do: Musics.Song

  @doc """
  Connected user can see voting and published Top + Top he has created
  """
  def scoped(%Accounts.User{} = _user), do: Musics.Song

  @doc """
  Not connected users see nothing
  """
  def scoped(nil) do
    from s in Musics.Song,
    join: r in assoc(s, :ranks),
    where: r.position <= 10
  end

  @doc """
  Search query
  """
  def search(query, ""), do: from q in query, where: false

  def search(query, search_query) do
    search_query = ts_query_format(search_query)

    from q in query,
    where: fragment("""
            (to_tsvector(
                'english',
                coalesce(artist, '') || ' ' ||  coalesce(title, '')
            ) @@ to_tsquery('english', ?))
            """, ^search_query),
    limit: 5
  end

  defp ts_query_format(search_query) do
    search_query
    |> String.trim
    |> String.split(" ")
    |> Enum.map(&("#{&1}:*"))
    |> Enum.join(" & ")
  end


  @doc """
  Preload user
  """
  def with_users(query) do
    from q in query,
    preload: [user: :avatar]
  end

  @doc """
  Preload comments and user comments
  """
  def with_comments(query) do
    from q in query,
    preload: [comments: :user]
  end

  @doc """
  Preload album art
  """
  def with_album_art(query) do
    from q in query,
    preload: :art
  end

  @doc """
  Preload song opinions ans user
  """
  def with_opinions(query) do
    from q in query,
    preload: [opinions: :user]
  end

  @doc """
  Preload everything connected to the song
  """
  def with_all(query) do
    query
    |> Musics.Song.with_users()
    |> Musics.Song.with_comments()
    |> Musics.Song.with_album_art()
    |> Musics.Song.with_opinions()
  end

  @doc """
  Last month
  """
  def last_month(query) do
    dt = DateTime.to_date(DateTime.utc_now)
    {:ok, naive_dtime} = NaiveDateTime.new(dt.year, dt.month, 1, 0, 0, 0)

    from q in query,
    where: q.inserted_at > date_add(^naive_dtime, -1, "month")
  end

  defp validate_url(changeset, field, options \\ []) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_char_list |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect msg}"}]
      end
    end
  end
end
