defmodule WsdjsWeb.Api.CommentController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Musics.{Comment, Song}

  def index(conn, %{"song_id" => song_id}) do
    with song <- Musics.get_song!(song_id) do
      comments = Musics.list_comments(song)

      conn
      |> put_status(:created)
      |> render("index.json", comments: comments)
    end
  end
end
