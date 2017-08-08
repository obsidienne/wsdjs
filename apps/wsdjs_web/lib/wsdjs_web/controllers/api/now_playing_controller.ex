defmodule WsdjsWeb.Api.NowPlayingController do
  @moduledoc false
  use WsdjsWeb, :controller

  require Logger

  def index(conn, _params) do
    pid = Process.whereis(Wsdjs.Jobs.NowPlaying)
    list = Wsdjs.Jobs.NowPlaying.read(pid)

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Poison.encode!(list))
  end
end
