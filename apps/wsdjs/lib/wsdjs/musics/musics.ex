defmodule Wsdjs.Musics do
  @moduledoc """
  The boundary for the Music system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  def instant_hits do
    Song
    |> where(instant_hit: true)
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def songs_interval(%User{} = user) do
    songs =
      user
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
  def list_songs(%User{} = user, %Date{} = month, q) do
    begin_period = Timex.to_datetime(Timex.beginning_of_month(month))
    end_period = Timex.to_datetime(Timex.end_of_month(month))

    user
    |> Song.scoped()
    |> where(
      [s],
      s.inserted_at >= ^begin_period and s.inserted_at <= ^end_period and s.suggestion == true
    )
    |> order_by(desc: :inserted_at)
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> Repo.all()
  end

  @doc """
  Returns the songs added the 24 last hours.
  """
  def list_songs(%DateTime{} = lower, %DateTime{} = upper) when lower < upper do
    query = from(s in Song, where: s.inserted_at >= ^lower and s.inserted_at <= ^upper)

    Repo.all(query)
  end

  def list_suggested_songs(%DateTime{} = lower, %DateTime{} = upper) when lower < upper do
    query =
      from(
        s in Song,
        where: s.inserted_at >= ^lower and s.inserted_at <= ^upper and s.suggestion == true
      )

    Repo.all(query)
  end

  def last_suggested_song(%User{} = user) do
    query =
      from(
        s in Song,
        where: s.suggestion == true and s.user_id == ^user.id,
        order_by: [desc: s.inserted_at],
        preload: [:art],
        limit: 1
      )

    Repo.one(query)
  end

  @doc """
  How many suggested songs for the user
  """
  def count_suggested_songs(%User{} = user) do
    query = from(s in Song, where: s.suggestion == true and s.user_id == ^user.id)
    Repo.aggregate(query, :count, :id)
  end

  @doc """
  Paginate the songs scoped by the current_user.
  """
  def paginate_songs(current_user, paginate_params \\ %{}) do
    current_user
    |> Song.scoped()
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by(desc: :inserted_at)
    |> Repo.paginate(paginate_params)
  end

  @doc """
  Paginate the songs suggested by a user scoped by current user.
  """
  def paginate_songs_user(current_user, user_id, paginate_params \\ %{}) do
    current_user
    |> Song.scoped()
    |> where(user_id: ^user_id)
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by(desc: :inserted_at)
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
    |> Song.create_changeset(params)
    |> Repo.insert()
  end

  def create_song!(params) do
    %Song{}
    |> Song.create_changeset(params)
    |> Repo.insert!()
  end

  @doc """
  Creates a suggestion.

  ## Examples

      iex> create_suggestion(%{field: value})
      {:ok, %Song{}}

      iex> create_suggestion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_suggestion(params) do
    %Song{}
    |> Song.suggestion_changeset(params)
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
  Get the song matching the "artist - title" pattern.
  The uniq index artist / title ensure the uniquenes of result.
  This a privileged function, no song restriction access.
  """
  def get_song_by(artist, title) when is_binary(artist) and is_binary(title) do
    Song
    |> where([s], fragment("lower(?)", s.title) == ^String.downcase(title))
    |> where([s], fragment("lower(?)", s.artist) == ^String.downcase(artist))
    |> preload([:user, :art])
    |> preload(tops: :ranks)
    |> Repo.one()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{source: %Song{}}

  """
  def change_song(%Song{} = song) do
    Song.update_changeset(song, %{})
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update_song(song, %{field: new_value}, %User{})
      {:ok, %Song{}}

      iex> update_song(song, %{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}

  """
  def update_song(%Song{} = song, attrs, %User{admin: false}) do
    song
    |> Song.update_changeset(attrs)
    |> Repo.update()
  end

  def update_song(%Song{} = song, attrs, %User{admin: true}) do
    song
    |> Song.admin_changeset(attrs)
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
end
