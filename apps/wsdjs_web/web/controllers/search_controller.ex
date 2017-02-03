defmodule WsdjsWeb.SearchController do
  use WsdjsWeb.Web, :controller

  plug :put_layout, false

  def index(conn, %{"q" => q}) do
    songs = Wcsp.search(q)

    render conn, "index.html", songs: songs
  end
end
