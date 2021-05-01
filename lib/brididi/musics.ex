defmodule Brididi.Musics do
  @moduledoc """
  The boundary for the Music system.
  """

  import Ecto.Query, warn: false
  alias Brididi.Repo

  alias Brididi.Accounts
  alias Brididi.Accounts.User
  alias Brididi.Musics
  alias Brididi.Musics.Song

  @doc """
  The scope rules are
    - admin can access any songs
  """
  def scoped(%Accounts.User{admin: true}), do: Song
  def scoped(%Accounts.User{profil_djvip: true}), do: Song

  def scoped(%Accounts.User{profil_dj: true} = user) do
    upper = Timex.shift(Timex.beginning_of_month(Timex.now()), months: -3)
    lower = Timex.shift(upper, months: -24)

    # credo:disable-for-lines:2
    scoped(lower, upper)
    |> or_where([s], s.user_id == ^user.id)
  end

  def scoped(%Accounts.User{} = user) do
    upper = Timex.shift(Timex.beginning_of_month(Timex.now()), months: -3)
    lower = Timex.shift(upper, months: -12)

    # credo:disable-for-lines:2
    scoped(lower, upper)
    |> or_where([s], s.user_id == ^user.id)
  end

  def scoped(nil) do
    lower = Timex.shift(Timex.beginning_of_month(Timex.now()), months: -6)
    upper = Timex.shift(Timex.beginning_of_month(Timex.now()), months: -3)

    scoped(lower, upper)
  end

  defp scoped(%DateTime{} = lower, %DateTime{} = upper) do
    from(
      s in Musics.Song,
      left_join: r in assoc(s, :ranks),
      left_join: t in assoc(r, :top),
      where:
        (t.status == "published" and r.position <= 10 and t.due_date >= ^lower and
           t.due_date <= ^upper) or s.instant_hit == true or s.public_track == true
    )
  end

  @doc """
  The policies are
    - admin can do anything
    - user can do anything to his own song
  """
  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, _, %Song{user_id: id}), do: :ok
  def can?(_, :show, %Song{public_track: true}), do: :ok
  def can?(_, :show, %Song{instant_hit: true}), do: :ok
  def can?(%User{profil_djvip: true}, :show, %Song{hidden_track: true}), do: :ok

  def can?(user, :show, %Song{id: id}) do
    song = Repo.get(Musics.scoped(user), id)

    case song do
      %Song{} -> :ok
      nil -> {:error, :unauthorized}
    end
  end

  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(%User{profil_djvip: true}, :suggest), do: :ok
  def can?(%User{admin: true}, :create), do: :ok
  def can?(%User{}, :search), do: :ok
  def can?(%User{}, :list_user_suggestions), do: :ok

  def can?(_, _), do: {:error, :unauthorized}

  def instant_hits do
    Song
    |> where(instant_hit: true)
    |> order_by(desc: :inserted_at)
    |> limit(6)
    |> Repo.all()
  end

  def list_songs(%User{} = user, criteria) when is_list(criteria) do
    query = Musics.scoped(user)

    # query = from(d in Song)

    Enum.reduce(criteria, query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from q in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]

      {:query, %{q: ""}}, query ->
        query

      {:query, %{q: q}}, query ->
        q =
          q
          |> String.trim()
          |> String.split(" ")
          |> Enum.map(&"#{&1}:*")
          |> Enum.join(" & ")

        query
        |> where(
          fragment(
            "(to_tsvector('english', coalesce(artist, '') || ' ' ||  coalesce(title, '')) @@ to_tsquery('english', ?))",
            ^q
          )
        )
    end)
    |> Repo.all()
  end

  @doc """
  Retrieve the songs matching the lower and upper date
  """
  def list_songs(%Date{} = lower, %Date{} = upper) when lower < upper do
    lower = NaiveDateTime.new!(lower, ~T[00:00:00.000])
    upper = NaiveDateTime.new!(upper, ~T[23:59:59.999])

    query =
      from(s in Song,
        where: s.inserted_at >= ^lower and s.inserted_at <= ^upper
      )

    Repo.all(query)
  end

  @doc """
  Returns the songs filtered by facets.
  """
  def list_songs(%User{} = user) do
    user
    |> Musics.scoped()
    |> order_by(desc: :inserted_at)
    |> preload(user: :user_profil, comments: :user, opinions: :user)
    |> limit(15)
    |> Repo.all()
  end

  def count_songs(%User{} = user), do: Repo.aggregate(Musics.scoped(user), :count, :id)
  def count_songs(), do: Repo.aggregate(Brididi.Musics.Song, :count, :id)

  def count_artists() do
    query = from(s in Brididi.Musics.Song, distinct: true, select: s.artist)
    Repo.aggregate(query, :count, :artist)
  end

  def bpm_ranges do
    %{
      "vs" => 1..69,
      "s" => 70..89,
      "m" => 90..109,
      "f" => 110..129,
      "vf" => 130..9999
    }
  end

  def preload_songs(tops) when is_list(tops), do: Repo.preload(tops, :songs)

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
    |> Song.create_changeset(params)
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
  def get_song!(id, to_preload \\ [:user]) do
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
  def change(%Song{} = song) do
    Song.update_changeset(song, %{})
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update(song, %{field: new_value})
      {:ok, %Song{}}

      iex> update(song, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Song{} = song, attrs) do
    song
    |> Song.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Song.

  ## Examples

      iex> delete(song)
      {:ok, %Song{}}

      iex> delete(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Song{} = song) do
    Repo.delete(song)
  end

  # #########
  # VIDEOS
  # #########

  alias Brididi.Musics.Video

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Videox@x@ does not exist.

  ## Examples

      iex> get_video!(123)
      %Comment{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos(%Song{})
      [%Video{}, ...]
  """
  def list_videos(%Song{id: id}) do
    Video
    |> where(song_id: ^id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
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

  def count_videos(), do: Repo.aggregate(Brididi.Musics.Video, :count, :id)
end
