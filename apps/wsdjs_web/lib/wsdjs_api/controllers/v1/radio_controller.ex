defmodule WsdjsApi.V1.RadioController do
  @moduledoc false
  use WsdjsWeb, :controller

  require Logger

  def index(conn, _params) do
    songs = WsdjsApi.Service.RadioSrv.streamed(conn)

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, songs)
  end
end
