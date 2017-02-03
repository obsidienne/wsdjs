defmodule WsdjsWeb.HottestController do
  use WsdjsWeb.Web, :controller
  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
    songs = Wcsp.songs_with_album_art()

    render conn, "index.html", songs: songs
  end

  def show(conn, _params) do
    render conn, "show.html"
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
