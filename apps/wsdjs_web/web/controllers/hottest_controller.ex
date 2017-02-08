defmodule WsdjsWeb.HottestController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    songs = Wcsp.hot_songs()

    render conn, "index.html", songs: songs
  end
end
