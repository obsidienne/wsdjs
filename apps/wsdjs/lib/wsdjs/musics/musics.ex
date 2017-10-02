defmodule Wsdjs.Musics do
  @moduledoc """
  The boundary for the Music system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

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
    |> limit(3)
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

  def instant_hits do
    Song
    |> where(instant_hit: true)
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by([desc: :inserted_at])
    |> Repo.all()
  end

  def songs_interval(%User{} = user) do
    songs = user
    |> Song.scoped()
    |> select([s], %{max: max(s.inserted_at), min: min(s.inserted_at)})
    |> Repo.one()

    %{
      min: Timex.to_date(Timex.beginning_of_month(songs[:min])),
      max: Timex.to_date(Timex.beginning_of_month(songs[:max]))
    }
  end

  @doc """
  Returns the songs added the 24 last hours.
  """
  def list_songs(%User{} = user, :month, %Date{} = month) do
    begin_period = Timex.to_datetime(Timex.beginning_of_month(month))
    end_period = Timex.to_datetime(Timex.end_of_month(month))

    user
    |> Song.scoped()
    |> where([s], s.inserted_at >= ^begin_period and s.inserted_at <= ^end_period)
    |> order_by([desc: :inserted_at])
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
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

  def list_songs_for_month(%Date{} = month) do
    lower = Timex.beginning_of_month(Timex.to_datetime(month))
    upper = Timex.end_of_month(Timex.to_datetime(month))
    query = from s in Song, where: s.inserted_at >= ^lower and s.inserted_at <= ^upper

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
  Gets a single song.

  Raises `Ecto.NoResultsError` if the Song does not exist.

  ## Examples

      iex> get_song!(123)
      %Song{}

      iex> get_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song!(id, to_preload \\ [:art, :user]) do
    Song
    |> Repo.get!(id)
    |> Repo.preload(to_preload)
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
  # Video
  #
  ###############################################
  alias Wsdjs.Musics.Video

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos(%Song{})
      [%Video{}, ...]
  """
  def list_videos(%Song{id: id}) do
    Video
    |> where([song_id: ^id])
    |> order_by([desc: :inserted_at])
    |> Repo.all
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(params) do
    %Video{}
    |> Video.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  ###############################################
  #
  # Comment
  #
  ###############################################

  alias Wsdjs.Musics.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments(%Song{})
      [%Comment{}, ...]
  """
  def list_comments(%Song{id: id}) do
    Comment
    |> where([song_id: ^id])
    |> order_by([desc: :inserted_at])
    |> Repo.all
    |> Repo.preload([user: :avatar])
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(params) do
    {:ok, comment} = %Comment{}
    |> Comment.changeset(params)
    |> Repo.insert()

    {:ok, Repo.preload(comment, [user: :avatar])}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
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
  Gets a single opinion by parameters.

  Raises `Ecto.NoResultsError` if the Opinion does not exist.

  ## Examples

      iex> get_opinion!(params)
      %Opinion{}

      iex> get_opinion!(not_matching_params)
      ** (Ecto.NoResultsError)

  """
  def get_opinion_by(params), do: Repo.get_by(Opinion, params)

  @doc """
  Gets the opinion total value of opinions list.

  ## Examples

      iex> opinions_value([%{kind: "up"}, %{kind: "down"}, %{kind: "like"}])
      3

  """
  def opinions_value(opinions) when is_list(opinions) do
    Enum.reduce(opinions, 0, fn(opinion, acc) ->
      case opinion.kind do
        "up"   -> acc + 4
        "like" -> acc + 2
        "down" -> acc - 3
        _      -> acc
      end
    end)
  end

  @doc """
  List opinions for a song

    ## Examples

      iex> list_opinions(%Song{})
      [%Opinion{}, ...]
  """
  def list_opinions(%Song{id: id}) do
    Opinion
    |> where([song_id: ^id])
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
  Returns an `%Ecto.Changeset{}` for tracking opinion changes.

  ## Examples

      iex> change_opinion(opinion)
      %Ecto.Changeset{source: %Opinion{}}

  """
  def change_opinion(%Opinion{} = opinion) do
    Opinion.changeset(opinion, %{})
  end

  @doc """
  Update or create an opinion.

  """
  def upsert_opinion(%User{id: user_id}, %Song{id: song_id}, kind) do
    opinion = case get_opinion_by(user_id: user_id, song_id: song_id) do
      nil  -> %Opinion{kind: kind, user_id: user_id, song_id: song_id}
      song_opinion -> song_opinion
    end

    opinion
    |> Opinion.changeset(%{kind: kind})
    |> Repo.insert_or_update()
  end
end
