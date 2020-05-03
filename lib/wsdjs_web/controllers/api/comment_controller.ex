defmodule WsdjsWeb.Api.CommentController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions.Comments

  action_fallback(WsdjsWeb.Api.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"song_id" => song_id}, _current_user) do
    with song <- Musics.Songs.get_song!(song_id) do
      comments = Comments.list(song)

      render(conn, "index.json", comments: comments)
    end
  end

  def create(conn, %{"song_id" => song_id, "comment" => params}, current_user) do
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

  def delete(conn, %{"id" => id}, current_user) do
    comment = Comments.get!(id)

    with :ok <- Comments.can?(current_user, :delete, comment),
         {:ok, _} <- Comments.delete(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
