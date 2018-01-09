defmodule WsdjsApi.V1.CommentController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions
  alias Wsdjs.Reactions.Comment

  action_fallback WsdjsWeb.Api.V1.FallbackController

  def index(conn, %{"song_id" => song_id}) do
    with song <- Musics.get_song!(song_id) do
      comments = Reactions.list_comments(song)

      render(conn, "index.json", comments: comments)
    end
  end

  def create(conn, %{"song_id" => song_id, "comment" => params}) do
    current_user = conn.assigns[:current_user]

    params = params
    |> Map.put("user_id", current_user.id)
    |> Map.put("song_id", song_id)

    with :ok <- Reactions.Policy.can?(current_user, :create_comment),
         {:ok, %Comment{} = comment} <- Reactions.create_comment(params) do

      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    comment = Reactions.get_comment!(id)
    with :ok <- Reactions.Policy.can?(current_user, :delete, comment),
         {:ok, %Comment{}} <- Reactions.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
