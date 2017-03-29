defmodule Wcsp.Trending do
  @moduledoc """
  The boundary for the trending system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  def last_top_10(user) do
    Wcsp.Top.scoped(user)
    |> order_by([desc: :due_date])
    |> where(status: "published")
    |> limit(1)
    |> Repo.one
    |> Repo.preload(ranks: Wcsp.Rank.for_tops_with_limit(10))
    |> Repo.preload(ranks: :song)
    |> Repo.preload(ranks: [song: :album_art])
    |> Repo.preload(ranks: [song: :user])
  end
end
