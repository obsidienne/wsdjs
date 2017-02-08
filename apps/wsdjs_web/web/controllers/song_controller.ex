defmodule WsdjsWeb.SongController do
  use WsdjsWeb.Web, :controller

  plug :authenticate

  def show(conn, %{"id" => id}) do
    song = Wcsp.find_song!(id: id)

    render conn, "show.html", song: song
  end


  # check if the action page is authorized, then in the function according to the
  # struct check if it's authorized
  defp authenticate(conn, _opts) do
    user = conn.assigns[:current_user]
    action = conn.assigns[:action] || conn.private[:phoenix_action]

    if Wscp.Policy.can?(user, action, Song) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
