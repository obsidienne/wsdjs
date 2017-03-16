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

  def last_top_10(user) do
    Top.scoped(user)
    |> order_by([desc: :due_date])
    |> where(status: "published")
    |> limit(1)
    |> Repo.one
    |> Repo.preload(ranks: Wcsp.Rank.for_tops_with_limit(10))
    |> Repo.preload(ranks: :song)
    |> Repo.preload(ranks: [song: :album_art])
    |> Repo.preload(ranks: [song: :user])
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

  def tops do
    tops = Wcsp.Top.tops() |> Repo.all
    Repo.preload tops, ranks: Wcsp.Rank.for_tops_with_limit()
  end

  def top(id) do
    top = Wcsp.Top.top(id) |> Repo.one
    top = Repo.preload top, :user
    Repo.preload top, ranks: Wcsp.Rank.for_top(id)
  end

  def create_top(user, %{"due_date" => due_date} = params) do
    dt = Ecto.Date.cast!(due_date)
    {:ok, naive_dtime} = NaiveDateTime.new(dt.year, dt.month, dt.day, 0, 0, 0)
    query = from s in Song, where: s.inserted_at >= ^naive_dtime and s.inserted_at < date_add(^dt, 1, "month")
    songs = Repo.all(query)

    Top.create_changeset(%Top{}, params)
    |> put_assoc(:songs, songs)
    |> put_assoc(:user, user)
    |> Repo.insert
  end

  def vote(user, %{"top_id" => top_id, "votes" => votes_param}) do
    top = top(top_id)
    top = Repo.preload top, rank_songs: Wcsp.RankSong.for_user_and_top(top, user)

    new_votes = Map.keys(votes_param)
    |> Enum.reject(fn(v) -> votes_param[v] == "0" end)
    |> Enum.map(&Wcsp.RankSong.get_or_build(top, user.id, &1, votes_param[&1]))

    top
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:rank_songs, new_votes)
    |> Repo.update()
  end

  def search(user, q) do
    Song.scoped(user)
    |> Song.with_users()
    |> Song.with_album_art()
    |> Song.search(q)
    |> Repo.all()
  end
end
