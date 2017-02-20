defmodule Wcsp do
  @moduledoc ~S"""
  Contains main business logic of the project.

  `Wcsp` is used by `wsdjs_web` Phoenix app.
  """
  use Wcsp.Model

  def users do
    User
    |> Repo.all
  end

  def find_user!(clauses) do
    Repo.get_by!(User, clauses)
    |> Repo.preload(:avatar)
  end

  def find_user(clauses) do
    Repo.get_by(User, clauses)
    |> Repo.preload(:avatar)
  end

  def hot_songs(user) do
    Wcsp.Scope.scope(Song, user)
    |> preload([:album_art, :user, :song_opinions, :comments])
    |> order_by(desc: :inserted_at)
    |> Repo.all
  end

  def find_song!(user, clauses) do
    Wcsp.Scope.scope(Song, user)
    |> Repo.get_by!(clauses)
    |> Repo.preload([:album_art, :user, :song_opinions, :comments])
    |> Repo.preload(song_opinions: :user)
  end

  def create_song(user, params) do
    Song.changeset(%Song{}, params)
    |> put_assoc(:user, user)
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

  def tops do
    tops = Wcsp.Top.tops() |> Repo.all
    Repo.preload tops, ranks: Wcsp.Rank.for_tops_with_limit()
  end

  def top(id) do
    top = Wcsp.Top.top(id) |> Repo.one
    top_with_songs = Repo.preload top, ranks: Wcsp.Rank.for_top(id)
  end

  def search(user, q) do
  query = from s in Wcsp.Scope.scope(Song, user),
    join: aa in assoc(s, :album_art),
    join: u in assoc(s, :user),
    join: a in assoc(u, :avatar),
    where: fragment("artist % ?", ^q) or fragment("title % ?", ^q),
    order_by: fragment("rank DESC"),
    limit: 5,
    select: %{id: s.id, artist: s.artist, title: s.title, genre: s.genre,
              bpm: s.bpm, inserted_at: s.inserted_at,
              album_art_cld_id: aa.cld_id, album_art_version: aa.version,
              avatar_cld_id: a.cld_id, avatar_version: a.version,
              name: u.name, djname: u.djname,
              rank: fragment("COALESCE(similarity(artist, ?), 0) + COALESCE(similarity(title, ?), 0) AS rank", ^q, ^q)}

    Repo.all(query)
  end
end
