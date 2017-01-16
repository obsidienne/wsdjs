defmodule WsdjsWeb.SongController do
  use WsdjsWeb.Web, :controller

  def show(conn, params) do
    render conn, "show.html"
  end
end
