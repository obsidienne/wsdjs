defmodule Wcsp.Trending do
  @moduledoc """
  The boundary for the trending system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Top

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
end
