defmodule WsdjsApi.CommentController do
  @moduledoc false
  use WsdjsApi, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions.Comments

  action_fallback(WsdjsApi.V1.FallbackController)

  def index(conn, %{"song_id" => song_id}) do
    with song <- Musics.Songs.get_song!(song_id) do
      comments = Comments.list(song)

      render(conn, "index.json", comments: comments)
    end
  end

  def create(conn, %{"song_id" => song_id, "comment" => params}) do
    current_user = conn.assigns[:current_user]
    song = Musics.Songs.get_song!(song_id)

    params =
      params
      |> Map.put("user_id", current_user.id)
      |> Map.put("song_id", song_id)

    with :ok <- Comments.can?(current_user, :create, song),
         {:ok, comment} <- Comments.create(params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    comment = Comments.get!(id)

    with :ok <- Comments.can?(current_user, :delete, comment),
         {:ok, _} <- Comments.delete(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
