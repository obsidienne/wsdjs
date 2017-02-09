defmodule WsdjsWeb.HottestController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    songs = Wcsp.hot_songs(user)

    render conn, "index.html", songs: songs
  end
end
