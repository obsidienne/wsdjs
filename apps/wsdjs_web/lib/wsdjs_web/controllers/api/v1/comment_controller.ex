defmodule WsdjsWeb.Api.V1.CommentController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.{Musics, Accounts}
  alias Wsdjs.Musics.Comment

  action_fallback WsdjsWeb.Api.V1.FallbackController

  def create(conn, %{"song_id" => song_id, "comment" => params}) do
    current_user = conn.assigns[:current_user]
    song = Musics.get_song!(current_user, song_id)

    params = params
    |> Map.put("user_id", current_user.id)
    |> Map.put("song_id", song.id)

    with {:ok, %Comment{} = comment} <- Musics.create_comment(params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end
end
