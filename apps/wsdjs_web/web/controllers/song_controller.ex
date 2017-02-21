defmodule WsdjsWeb.SongController do
  use WsdjsWeb.Web, :controller

  plug :authenticate

  def show(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]
    song = Wcsp.find_song!(user, id: id)
    |> Wcsp.Repo.preload(:comments)
    |> Wcsp.Repo.preload(comments: :user)

    render conn, "show.html", song: song
  end

  # check if the action page is authorized, then in the function according to the
  # struct check if it's authorized
  defp authenticate(conn, _opts) do
    user = conn.assigns[:current_user]
    action = conn.assigns[:action] || conn.private[:phoenix_action]

    if Wcsp.Policy.can?(user, action, Wcsp.Song) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
