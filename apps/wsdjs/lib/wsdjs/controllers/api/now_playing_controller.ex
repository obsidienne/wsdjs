defmodule Wsdjs.NowPlayingController do
    use Wsdjs, :controller

    require Logger

    def pretty_json(conn, data) do
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(200, Poison.encode!(data, pretty: true))
    end

    def index(conn, _params) do
        pid = Process.whereis(Wcsp.NowPlaying)
        list = Wcsp.NowPlaying.read(pid)
        pretty_json conn, list
    end
end
