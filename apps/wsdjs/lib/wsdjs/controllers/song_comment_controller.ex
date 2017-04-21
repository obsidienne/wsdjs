defmodule Wsdjs.SongCommentController do
  require Logger
  use Wsdjs, :controller

  def create(conn, %{"song_id" => song_id, "comment" => params}) do
    current_user = conn.assigns[:current_user]

    case Wcsp.Musics.create_comment(current_user, song_id, params) do
      {:ok, _} ->
        conn
        |> redirect(to: song_path(conn, :show, song_id))
      {:error, changeset} ->
        conn
        |> put_flash(:error, %{title: "Error on comment !", body: "Error"})
        |> redirect(to: song_path(conn, :show, song_id))
    end
  end
end
