defmodule Wcsp.Musics do
  @moduledoc """
  The boundary for the Dj system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Musics.{Song, Comment, Opinion}

  @doc """
  Returns the list of songs.the current and previous month

  ## Examples

      iex> list_songs()
      [%User{}, ...]

  """
  def list_songs(current_user) do
    Song.scoped(current_user)
    |> Song.with_all()
    |> Song.last_month()
    |> Repo.all
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

  def create_song(user, params) do
    Song.changeset(%Song{}, params)
    |> put_assoc(:user, user)
    |> Repo.insert
  end

  def create_song_comment(user, song, params) do
    Comment.changeset(%Comment{}, params)
    |> put_assoc(:user, user)
    |> put_assoc(:song, song)
    |> Repo.insert
  end

  def upsert_opinion!(user, song, kind) do
    song_opinion = case Repo.get_by(Opinion, user_id: user.id, song_id: song.id) do
      nil  -> Opinion.build(%{kind: kind, user_id: user.id, song_id: song.id})
      song_opinion -> song_opinion
    end

    song_opinion
    |> Opinion.changeset(%{kind: kind})
    |> Repo.insert_or_update
  end

  def delete_song_opinion!(_user, clauses) do
    Repo.get_by(Opinion, clauses)
    |> Repo.delete!()
  end

  def find_song_opinion(clauses) do
    Repo.get_by(Opinion, clauses)
  end

  def search(user, q) do
    Song.scoped(user)
    |> Song.with_users()
    |> Song.with_album_art()
    |> Song.search(q)
    |> Repo.all()
  end
end
