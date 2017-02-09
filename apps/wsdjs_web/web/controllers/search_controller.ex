defmodule WsdjsWeb.SearchController do
  use WsdjsWeb.Web, :controller

  plug :put_layout, false

  def index(conn, %{"q" => q}) do
    user = conn.assigns[:current_user]
    songs = Wcsp.search(user, q)

    render conn, "index.html", songs: songs
  end
end
