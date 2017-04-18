defmodule Wcsp.Musics do
  @moduledoc """
  The boundary for the Dj system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Musics.{Song, Comment, Opinion, Art}

  def search(user, q) do
    Song.scoped(user)
    |> preload([:art, user: :avatar])
    |> Song.search(q)
    |> Repo.all()
  end

  @doc """
  Returns the list of songs.the current and previous month
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
  Returns the list of songs for the user scoped by current_user
  """
  def list_songs(current_user, user) do
    Song.scoped(user)
    |> where([user_id: ^user.id])
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> Repo.all()
  end

  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{email: "test@testing.com"})
      {:ok, %Wcsp.Musics.Song{}}

      iex> create_song(%{email: "dummy value"})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(user, params) do
    Song.changeset(%Song{}, params)
    |> put_assoc(:user, user)
    |> Repo.insert
  end

  def find_song!(user, clauses) do
    Song.scoped(user)
    |> preload([:art, user: :avatar, comments: :user, opinions: :user])
    |> Repo.get_by!(clauses)
  end

  def get_song!(user, id) do
    Song.scoped(user)
    |> Repo.get!(id)
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
    |> order_by([desc: :inserted_at])
    |> Repo.all
    |> Enum.count
  end


  def create_comment(user, song, params) do
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
  List comments for a song order by desc
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

  def upsert_opinion!(user, song_id, kind) do
    song_opinion = case Repo.get_by(Opinion, user_id: user.id, song_id: song_id) do
      nil  -> Opinion.build(%{kind: kind, user_id: user.id, song_id: song_id})
      song_opinion -> song_opinion
    end

    song_opinion
    |> Opinion.changeset(%{kind: kind})
    |> Repo.insert_or_update
  end
end
