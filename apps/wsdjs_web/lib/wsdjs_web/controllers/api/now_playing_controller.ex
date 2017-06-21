defmodule Wsdjs.API.NowPlayingController do
  use Wsdjs.Web, :controller

    require Logger

    def pretty_json(conn, data) do
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(200, Poison.encode!(data, pretty: true))
    end

    def index(conn, _params) do
        pid = Process.whereis(Wsdjs.NowPlaying)
        list = Wsdjs.NowPlaying.read(pid)
        pretty_json conn, list
    end
end
