defmodule WsdjsApi.V1.NowPlayingController do
  @moduledoc false
  use WsdjsApi, :controller

  require Logger

  def index(conn, _params) do
    pid = Process.whereis(Wsdjs.Jobs.NowPlaying)
    list = Wsdjs.Jobs.NowPlaying.read(pid)

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Poison.encode!(list))
  end
end
