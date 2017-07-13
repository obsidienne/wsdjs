defmodule Wsdjs.Web.Api.V1.CommentController do
  @moduledoc false
  use Wsdjs.Web, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Musics.Comment

  action_fallback Wsdjs.Web.Api.V1.FallbackController

  def create(conn, %{"song_id" => song_id, "comment" => params}) do
    current_user = conn.assigns[:current_user]

    with {:ok, %Comment{} = comment} <- Musics.create_comment(current_user, song_id, params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end
end
