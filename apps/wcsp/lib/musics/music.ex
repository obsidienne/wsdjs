defmodule Wcsp.Music do
  @moduledoc """
  The boundary for the Dj system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.{Song, SongComment}

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
    Wcsp.Music.find_song!(user, id: id)
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
    SongComment.changeset(%SongComment{}, params)
    |> put_assoc(:user, user)
    |> put_assoc(:song, song)
    |> Repo.insert
  end

  def upsert_opinion!(user, song, kind) do
    song_opinion = case Repo.get_by(SongOpinion, user_id: user.id, song_id: song.id) do
      nil  -> SongOpinion.build(%{kind: kind, user_id: user.id, song_id: song.id})
      song_opinion -> song_opinion
    end

    song_opinion
    |> SongOpinion.changeset(%{kind: kind})
    |> Repo.insert_or_update
  end

  def delete_song_opinion!(user, clauses) do
    Repo.get_by(SongOpinion, clauses)
    |> Repo.delete!()
  end

  def find_song_opinion(clauses) do
    Repo.get_by(SongOpinion, clauses)
  end

  def search(user, q) do
    Song.scoped(user)
    |> Song.with_users()
    |> Song.with_album_art()
    |> Song.search(q)
    |> Repo.all()
  end
end
