defmodule WsdjsWeb.HottestController do
  use WsdjsWeb.Web, :controller
  plug :authenticate when action in [:index]

  def index(conn, _params) do
    songs = Wcsp.hot_songs()

    render conn, "index.html", songs: songs
  end


  defp authenticate(conn, _opts) do
    user = conn.assigns[:current_user]
    action = conn.assigns[:action] || conn.private[:phoenix_action]

    if Wscp.Policy.can?(user, action, :hottest) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
