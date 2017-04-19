defmodule Wcsp.Trendings do
  @moduledoc """
  The boundary for the trending system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Trendings.{Top, Rank, Vote}
  alias Wcsp.Musics.Song

  def last_top(user) do
    Top.scoped(user)
    |> order_by([desc: :due_date])
    |> where(status: "published")
    |> limit(1)
    |> Repo.one
    |> Repo.preload(ranks: Wcsp.Trendings.Rank.for_tops_with_limit(10))
    |> Repo.preload(ranks: :song)
    |> Repo.preload(ranks: [song: :art])
    |> Repo.preload(ranks: [song: :user])
  end

  def list_tops(user) do
    Top.scoped(user)
    |> order_by([desc: :due_date])
    |> Repo.all
    |> Repo.preload(ranks: Rank.for_tops_with_limit())
  end

  def get_top(user, id) do
    Top.scoped(user)
    |> Repo.get!(id)
    |> Repo.preload(:user)
    |> Repo.preload(ranks: Rank.for_top(id))
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

  @doc """
  Change the top status.

  The steps are the following : check -> vote -> count -> publish
  The step create does not use this function.

  """
  def next_step(user, top) do
    next_step_value = case top.status do
      "checking" ->
        "voting"
      "voting" ->
        "counting"
      "counting" ->
        "published"
    end

    go_next_step(next_step_value, user, top)
  end

  @doc """
  The top creator is ok with the songs in the top. The top creator freeze the likes
  according to this rule: (like * 2) - (down * 3) + (up * 4)

  After that, DJs can vote for their top 10.
  """
  defp go_next_step(next_step, user, top) when next_step in ["voting"] do
    ranks = Rank
    |> where(top_id: ^top.id)
    |> preload(song: :opinions)
    |> Repo.all()

    Enum.each(ranks, fn(x) ->
      val = Enum.reduce(x.song.opinions, 0, fn(x, acc) ->
        case x.kind do
          "up"   -> acc + 4
          "like" -> acc + 2
          "down" -> acc - 3
          _      -> acc
        end
      end)

      Wcsp.Trendings.Rank.changeset(x, %{likes: val})
      |> Repo.update()
    end)

    Top.next_step_changeset(top, %{status: next_step})
    |> Repo.update()
  end

  @doc """
  The top creator decides it's time to publish the
  Need to sum the votes according to this rule
  vote = 10 * (nb vote for song) - (total vote position for song) + (nb vote for song)

  After that, the top creator can apply bonus to the top.
  """
  defp go_next_step(next_step, user, top) when next_step in ["counting"] do
    Top.next_step_changeset(top, %{status: next_step})
    |> Repo.update()
  end

  @doc """
  Need to calculate the position according to likes + votes + bonus.
  """
  defp go_next_step(next_step, user, top) when next_step in ["published"] do
    Top.next_step_changeset(top, %{status: next_step})
    |> Repo.update()
  end

  def list_votes(top) do
    Wcsp.Trendings.Vote
    |> where(top_id: ^top.id)
    |> Repo.all()
  end

  def list_votes(top, user) do
    from r in Wcsp.Trendings.Vote,
    where: r.user_id == ^user.id and r.top_id == ^top.id
  end

  def vote(user, %{"top_id" => top_id, "votes" => votes_param}) do
    top = get_top(user, top_id)
    top = Repo.preload top, votes: list_votes(top, user)

    new_votes = Map.keys(votes_param)
    |> Enum.reject(fn(v) -> votes_param[v] == "0" end)
    |> Enum.map(&Vote.get_or_build(top, user.id, &1, votes_param[&1]))

    top
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:votes, new_votes)
    |> Repo.update()
  end
end
