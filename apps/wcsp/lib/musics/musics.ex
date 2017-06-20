defmodule Wcsp.Musics do
  @moduledoc """
  The boundary for the Music system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Musics.{Song, Comment, Opinion, Art}

  @doc """
  Returns a song list according to a fulltext search.
  The song list is scoped for user.
  """
  def search(user, q) do
    Song.scoped(user)
    |> preload([:art, user: :avatar])
    |> Song.search(q)
    |> Repo.all()
  end


  def search_artist_title(artist_title) do
    Song
    |> where([s], fragment("? || ' - ' || ?", s.artist, s.title) == ^artist_title)
    |> preload([:user, :art, :tops])
    |> preload([tops: :ranks])
    |> Repo.one
  end

  @doc """
  Returns the list of songs for the current and the previous month.
  """
  def hot_songs(user) do
    dt = DateTime.to_date(DateTime.utc_now)
    {:ok, naive_dtime} = NaiveDateTime.new(dt.year, dt.month, 1, 0, 0, 0)

    Song.scoped(user)
    |> where([s], s.inserted_at > date_add(^naive_dtime, -1, "month"))
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> Repo.all()
  end

  @doc """
  Returns the list of songs for the user scoped by current_user.
  """
  def list_songs(current_user, user) do
    Song.scoped(user)
    |> where([user_id: ^user.id])
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> Repo.all()
  end

  @doc """
  Returns the list of songs scoped by current_user.
  """
  def list_songs(current_user) do
    Song.scoped(current_user)
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> order_by([desc: :inserted_at])
    |> Repo.paginate()
  end

  @doc """
  Creates a song.
  """
  def create_song(user, params) do
    Song.changeset(%Song{}, params)
    |> put_assoc(:user, user)
    |> Repo.insert
  end

  def get_song!(user, song_id) do
    Song.scoped(user)
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> Repo.get!(song_id)
  end

  @doc """
  List comments for a song order by desc
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


  def create_comment(user, song_id, params) do
    song = Song.scoped(user) |> Repo.get!(song_id)

    Comment.changeset(%Comment{}, params)
    |> put_assoc(:user, user)
    |> put_assoc(:song, song)
    |> Repo.insert
  end

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

  def upsert_opinion(user, song_id, kind) do
    song_opinion = case Repo.get_by(Opinion, user_id: user.id, song_id: song_id) do
      nil  -> Opinion.build(%{kind: kind, user_id: user.id, song_id: song_id})
      song_opinion -> song_opinion
    end

    song_opinion
    |> Opinion.changeset(%{kind: kind})
    |> Repo.insert_or_update()
  end
end
