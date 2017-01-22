defmodule WsdjsWeb.TopController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", tops: Wcsp.Dj.tops()
  end

  def show(conn, %{"id" => id}) do
    render conn, "show.html", top: Wcsp.Dj.top(id)
  end
end
