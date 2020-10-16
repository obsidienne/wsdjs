defmodule WsdjsWeb.OpinionController do
  @moduledoc false

  use WsdjsWeb, :controller

  alias Wsdjs.Songs
  alias Wsdjs.Reactions.Opinions

  @spec index(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def index(conn, %{"song_id" => song_id}) do
    with song <- Songs.get_song!(song_id) do
      opinions = Opinions.list(song)

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
