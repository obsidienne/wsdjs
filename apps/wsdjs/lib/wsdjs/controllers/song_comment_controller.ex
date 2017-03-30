defmodule Wsdjs.SongCommentController do
  require Logger
  use Wsdjs, :controller

  def create(conn, %{"song_id" => song_id, "song_comment" => params}) do
    user = conn.assigns[:current_user]
    song = Wcsp.Musics.find_song_with_comments!(user, id: song_id)

    case Wcsp.Musics.create_song_comment(user, song, params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "Comment added !")
        |> redirect(to: song_path(conn, :show, song_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error on comment !")
        |> redirect(to: song_path(conn, :show, song_id))
    end
  end
end
