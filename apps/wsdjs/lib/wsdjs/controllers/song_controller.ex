defmodule Wsdjs.SongController do
  use Wsdjs, :controller

  plug :authenticate

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    song = Wcsp.Musics.find_song!(current_user, id: id)
    comments = Wcsp.Musics.list_comments(id)
    comment_changeset = Wcsp.Musics.Comment.changeset(%Wcsp.Musics.Comment{})

    render conn, "show.html", song: song, comments: comments, comment_changeset: comment_changeset
  end

  # check if the action page is authorized, then in the function according to the
  # struct check if it's authorized
  defp authenticate(conn, _opts) do
    current_user = conn.assigns[:current_user]
    action = conn.assigns[:action] || conn.private[:phoenix_action]

    if Wcsp.Policy.can?(current_user, action, %Wcsp.Musics.Song{}) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: session_path(conn, :new))
      |> halt()
    end
  end
end
