defmodule Wsdjs.API.V1.CommentController do
  use Wsdjs, :controller

  alias Wcsp.Musics
  alias Wcsp.Musics.Comment

  action_fallback Gally.Web.FallbackController

  def create(conn, %{"song_id" => song_id, "comment" => params}) do
    current_user = conn.assigns[:current_user]

    with {:ok, %Comment{} = comment} <- Musics.create_comment(current_user, song_id, params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end
end
