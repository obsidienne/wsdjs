defmodule WsdjsApi.Web.RankView do
  use WsdjsApi.Web, :view
  alias WsdjsApi.Web.RankView

  def render("index.json", %{ranks: ranks}) do
    %{data: render_many(ranks, RankView, "rank.json")}
  end

  def render("show.json", %{rank: rank}) do
    %{data: render_one(rank, RankView, "rank.json")}
  end

  def render("rank.json", %{rank: rank}) do
    %{id: rank.id,
      likes: rank.likes,
      votes: rank.votes,
      bonus: rank.bonus,
      position: rank.position}
  end
end
