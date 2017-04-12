defmodule Wcsp.Musics do
  @moduledoc """
  The boundary for the Dj system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Musics.{Song, Comment, Opinion, Art}

  def search(user, q) do
    Song.scoped(user)
    |> Song.with_users()
    |> Song.with_art()
    |> Song.search(q)
    |> Repo.all()
  end


  @doc """
  Returns the list of songs.the current and previous month

  ## Examples

      iex> list_song()
      [%User{}, ...]

  """
  def list_songs(user) do
    Song.scoped(user)
    |> Song.with_all()
    |> Song.last_month()
    |> Repo.all
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
    |> Song.with_all()
    |> Repo.get_by!(clauses)
  end

  def find_song_with_comments!(user, id: id) do
    Wcsp.Musics.find_song!(user, id: id)
    |> Wcsp.Repo.preload(:comments)
    |> Wcsp.Repo.preload(comments: :user)
    |> Wcsp.Repo.preload(comments: [user: :avatar])
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
