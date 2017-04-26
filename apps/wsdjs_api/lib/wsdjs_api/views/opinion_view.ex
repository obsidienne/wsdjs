defmodule WsdjsApi.Web.OpinionView do
  use WsdjsApi.Web, :view
  alias WsdjsApi.Web.OpinionView

  def render("index.json", %{opinions: opinions}) do
    %{data: render_many(opinions, OpinionView, "opinion.json")}
  end

  def render("show.json", %{opinion: opinion}) do
    %{data: render_one(opinion, OpinionView, "opinion.json")}
  end

  def render("opinion.json", %{opinion: opinion}) do
    %{id: opinion.id,
      kind: opinion.kind}
  end
end
