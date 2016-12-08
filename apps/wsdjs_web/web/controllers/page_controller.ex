defmodule WsdjsWeb.PageController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
