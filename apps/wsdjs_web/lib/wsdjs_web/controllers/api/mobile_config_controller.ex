defmodule Wsdjs.Web.Api.MobileConfigController do
  @moduledoc false
  use Wsdjs.Web, :controller

  require Logger

  def pretty_json(conn, data) do
    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Poison.encode!(data, pretty: true))
  end

  def index(conn, _params) do
    list = %{
        ios_min_version_supported: "1.1.0",
        ios_current_version: "1.1.0",
        android_min_version_supported: "1.1.0",
        android_current_version: "1.1.0",
        min_version_supported: "1.1.0",
        current_version: "1.1.0",
        facebook_uri: "https://www.facebook.com/pages/Radio-West-Coast-Swing/244532062269363",
        website_uri: "http://www.radiowcs.com/",
        stream_uri: "http://37.58.75.166:8384/",
    }
    pretty_json conn, list
  end
end
