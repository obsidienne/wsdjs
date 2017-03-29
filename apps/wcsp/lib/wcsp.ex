defmodule Wcsp do
  @moduledoc ~S"""
  Contains main business logic of the project.

  `Wcsp` is used by `wsdjs` Phoenix app.
  """
  use Wcsp.Schema

  def find_user!(clauses) do
    User
    |> User.with_avatar()
    |> Repo.get_by!(clauses)
  end

  def find_user(clauses) do
    User
    |> User.with_avatar()
    |> Repo.get_by(clauses)
  end

  def find_user_with_songs(current_user, clauses) do
    User.scoped(current_user)
    |> User.with_avatar()
    |> User.with_songs(current_user)
    |> Repo.get_by(clauses)
  end


  def find_song!(user, clauses) do
    Song.scoped(user)
    |> Song.with_all()
    |> Repo.get_by!(clauses)
  end

  def find_song_with_comments!(user, id: id) do
    Wcsp.find_song!(user, id: id)
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
