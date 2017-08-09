defmodule Wsdjs.Musics do
  @moduledoc """
  The boundary for the Music system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song
  alias Wsdjs.Musics.Policy

  @doc """
  Returns a song list according to a fulltext search.
  The song list is scoped by current user.
  """
  def search(_current_user, ""), do: []
  def search(current_user, q) do
    q = q
        |> String.trim
        |> String.split(" ")
        |> Enum.map(&("#{&1}:*"))
        |> Enum.join(" & ")

    current_user
    |> Song.scoped()
    |> preload([:art, user: :avatar])
    |> where(fragment("(to_tsvector('english', coalesce(artist, '') || ' ' ||  coalesce(title, '')) @@ to_tsquery('english', ?))", ^q))
    |> order_by([desc: :inserted_at])
    |> limit(5)
    |> Repo.all()
  end

  @doc """
  Get the song matching the "artist - title" pattern. 
  The uniq index artist / title ensure the uniquenes of result. 
  This a privileged function, no song restriction access.
  """
  def search_by_artist_title(artist, title) do
    Song
    |> where([s], fragment("lower(?)", s.title) == ^String.downcase(title))
    |> where([s], fragment("lower(?)", s.artist) == ^String.downcase(artist))
    |> preload([:user, :art])
    |> preload([tops: :ranks])
    |> Repo.one
  end

  @doc """
  Returns the list of songs for the current and the previous month.
  This function is scoped by the current user.
  """
  def hot_songs(current_user) do
    dt = DateTime.to_date(DateTime.utc_now)
    {:ok, naive_dtime} = NaiveDateTime.new(dt.year, dt.month, 1, 0, 0, 0)

    current_user
    |> Song.scoped()
    |> where([s], s.inserted_at > date_add(^naive_dtime, -1, "month"))
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by([desc: :inserted_at])
    |> Repo.all()
  end

  def last_songs(current_user) do
    Song
    |> where(instant_hit: true)
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by([desc: :inserted_at])
    |> Repo.all()
  end

  @doc """
  Returns the list of songs for a user scoped by the current_user.
  """
  def list_songs(current_user, user) do
    current_user
    |> Song.scoped()
    |> where([user_id: ^user.id])
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by([desc: :inserted_at])
    |> Repo.all()
  end

  @doc """
  Returns the songs added the 24 last hours.
  """
  def list_songs do
    yesterday = Timex.shift(Timex.now, hours: -24)
    Song
    |> where([s], s.inserted_at > ^yesterday)
    |> order_by([desc: :inserted_at])
    |> Repo.all()
  end

  def songs_in_month(due_date) do
    dt = Ecto.Date.cast!(due_date)
    {:ok, naive_dtime} = NaiveDateTime.new(dt.year, dt.month, dt.day, 0, 0, 0)
    query = from s in Song, where: s.inserted_at >= ^naive_dtime and s.inserted_at < date_add(^dt, 1, "month")
    Repo.all(query)
  end

  @doc """
  Paginate the songs scoped by the current_user.
  """
  def paginate_songs(current_user, paginate_params \\ %{}) do
    current_user
    |> Song.scoped()
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by([desc: :inserted_at])
    |> Repo.paginate(paginate_params)
  end

  @doc """
  Paginate the songs suggested by a user scoped by current user.
  """
  def paginate_songs_user(current_user, user_id, paginate_params \\ %{}) do
    current_user
    |> Song.scoped()
    |> where([user_id: ^user_id])
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by([desc: :inserted_at])
    |> Repo.paginate(paginate_params)
  end

  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{field: value})
      {:ok, %Song{}}

      iex> create_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(params) do
    %Song{}
    |> Song.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Get a song according to it's ID scoped by current user.

  ## Examples

      iex> get_song!(%User{}, "song")
      %Song{}
  """
  def get_song!(current_user, song_id) do
    current_user
    |> Song.scoped()
    |> preload([:art, user: :avatar, comments: :user, opinions: [user: :avatar]])
    |> Repo.get!(song_id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{source: %Song{}}

  """
  def change_song(%Song{} = song) do
    Song.changeset(song, %{})
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update_song(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update_song(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_song(%Song{} = song, attrs) do
    song
    |> Song.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Song.

  ## Examples

      iex> delete_song(song)
      {:ok, %Song{}}

      iex> delete_song(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_song(%Song{} = song) do
    Repo.delete(song)
  end

  ###############################################
  #
  # Comment
  #
  ###############################################

  alias Wsdjs.Musics.Comment

  @doc """
  List comments for a song order by desc.
  """
  def list_comments(song_id) do
    Comment
    |> where([song_id: ^song_id])
    |> order_by([desc: :inserted_at])
    |> Repo.all
    |> Repo.preload([user: :avatar])
  end

  @doc """
  Count comments for a song
  """
  def count_comments(song_id) do
    Comment
    |> where([song_id: ^song_id])
    |> Repo.all
    |> Enum.count
  end

  @doc """
  This function add a comment to a song.
  """
  def create_comment(params) do
    {:ok, comment} = %Comment{}
    |> Comment.changeset(params)
    |> Repo.insert()

    {:ok, Repo.preload(comment, [user: :avatar])}
  end

  ###############################################
  #
  # Opinion
  #
  ###############################################

  alias Wsdjs.Musics.Opinion

  @doc """
  Gets a single opinion.

  Raises `Ecto.NoResultsError` if the Opinion does not exist.

  ## Examples

      iex> get_opinion!(123)
      %Opinion{}

      iex> get_opinion!(456)
      ** (Ecto.NoResultsError)

  """
  def get_opinion!(id), do: Repo.get!(Opinion, id)

  @doc """
  List opinions for a song order by desc
  """
  def list_opinions(song_id) do
    Opinion
    |> where([song_id: ^song_id])
    |> order_by([desc: :inserted_at])
    |> Repo.all
    |> Repo.preload([user: :avatar])
  end

  @doc """
  Deletes an Opinion.

  ## Examples

      iex> delete_opinion(opinion)
      {:ok, %Opinion{}}

      iex> delete_opinion(opinion)
      {:error, %Ecto.Changeset{}}

  """
  def delete_opinion(%Opinion{} = opinion) do
    Repo.delete(opinion)
  end

  @doc """
  This function modify the opinion for the current user.
  """
  def upsert_opinion(current_user, song_id, kind) do
    song_opinion = case Repo.get_by(Opinion, user_id: current_user.id, song_id: song_id) do
      nil  -> Opinion.build(%{kind: kind, user_id: current_user.id, song_id: song_id})
      song_opinion -> song_opinion
    end

    song_opinion
    |> Opinion.changeset(%{kind: kind})
    |> Repo.insert_or_update()
  end

  ###############################################
  #
  # Playlist
  #
  ###############################################

  alias Wsdjs.Musics.Playlist

  @doc """
  Returns the list of playlists.

  ## Examples

      iex> list_playlists()
      [%Playlist{}, ...]

  """
  def list_playlists do
    Repo.all(Playlist)
  end

  @doc """
  Gets a single playlist.

  Raises `Ecto.NoResultsError` if the Playlist does not exist.

  ## Examples

      iex> get_playlist!(123)
      %Playlist{}

      iex> get_playlist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_playlist!(id), do: Repo.get!(Playlist, id)

  @doc """
  Creates a playlist.

  ## Examples

      iex> create_playlist(%{field: value})
      {:ok, %Playlist{}}

      iex> create_playlist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_playlist(attrs \\ %{}) do
    %Playlist{}
    |> Playlist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a playlist.

  ## Examples

      iex> update_playlist(playlist, %{field: new_value})
      {:ok, %Song{}}

      iex> update_playlist(playlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_playlist(%Playlist{} = playlist, attrs) do
    playlist
    |> Playlist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Playlist.

  ## Examples

      iex> delete_playlist(playlist)
      {:ok, %Playlist{}}

      iex> delete_playlist(playlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_playlist(%Playlist{} = playlist) do
    Repo.delete(playlist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking playlist changes.

  ## Examples

      iex> change_playlist(playlist)
      %Ecto.Changeset{source: %Playlist{}}

  """
  def change_playlist(%Playlist{} = playlist) do
    Playlist.changeset(playlist, %{})
  end
end
