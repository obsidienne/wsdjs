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

  defp go_next_step("voting", user, top) do
    Top.next_step_changeset(top, %{status: "voting"})
    |> Repo.update()
  end


  defp go_next_step("counting", user, top) do
    :ok
  end

  defp go_next_step("publish", user, top) do
    :ok
  end

  def vote(user, %{"top_id" => top_id, "votes" => votes_param}) do
    top = get_top(user, top_id)
    top = Repo.preload top, votes: Vote.for_user_and_top(top, user)

    new_votes = Map.keys(votes_param)
    |> Enum.reject(fn(v) -> votes_param[v] == "0" end)
    |> Enum.map(&Vote.get_or_build(top, user.id, &1, votes_param[&1]))

    top
    |> Ecto.Changeset.change
    |> Ecto.Changeset.put_assoc(:votes, new_votes)
    |> Repo.update()
  end
end
