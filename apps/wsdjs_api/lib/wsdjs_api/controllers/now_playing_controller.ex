defmodule WsdjsApi.NowPlayingController do
  @moduledoc false
  use WsdjsApi, :controller

  require Logger

  def index(conn, _params) do
    pid = Process.whereis(WsdjsJobs.NowPlaying)
    list = WsdjsJobs.NowPlaying.read(pid)

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Poison.encode!(list))
  end
end
