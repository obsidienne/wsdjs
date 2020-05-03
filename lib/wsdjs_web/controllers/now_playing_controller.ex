defmodule WsdjsWeb.NowPlayingController do
  @moduledoc false
  use WsdjsWeb, :controller

  require Logger

  def index(conn, _params) do
    songs = WsdjsWeb.Service.RadioSrv.streamed(conn)

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, songs)
    end
end
