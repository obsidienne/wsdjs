defmodule WsdjsWeb.HottestController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    songs = Wcsp.Dj.songs_with_album_art()

    render conn, "index.html", songs: songs
  end

  def show(conn, params) do
    render conn, "show.html"
  end
end
