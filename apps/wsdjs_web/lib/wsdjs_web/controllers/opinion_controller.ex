defmodule WsdjsWeb.OpinionController do
  @moduledoc false

  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions

  @spec index(Plug.Conn.t(), map(), any()) :: Plug.Conn.t()
  def index(conn, %{"song_id" => song_id}, _current_user) do
    with song <- Musics.get_song!(song_id) do
      opinions = Reactions.list_opinions(song)

      conn
      |> put_layout(false)
      |> render(
        "_opinion_link.html",
        song: song,
        conn: conn,
        opinions: opinions
      )
    end
  end
end
