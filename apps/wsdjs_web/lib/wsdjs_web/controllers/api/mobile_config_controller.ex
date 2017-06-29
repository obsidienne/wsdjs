defmodule Wsdjs.Web.Api.MobileConfigController do
  use Wsdjs.Web, :controller

    require Logger

    def pretty_json(conn, data) do
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(200, Poison.encode!(data, pretty: true))
    end

    def index(conn, _params) do
        list = %{
            ios_min_version_supported: "1.1.1",
            ios_current_version: "1.2.3",
            android_min_version_supported: "1.1.1",
            android_current_version: "1.2.3",
        }
        pretty_json conn, list
    end
end
