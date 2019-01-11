defmodule WsdjsApi.RadioController do
  @moduledoc false
  use WsdjsApi, :controller

  require Logger

  def index(conn, _params) do
    songs = WsdjsApi.Service.RadioSrv.streamed(conn)

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, songs)
  end
end
