defmodule WsdjsApi.MobileConfigController do
  @moduledoc false
  use WsdjsWeb, :controller

  require Logger

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
      stream_uri: "http://www.radioking.com/play/radio-wcs/122560",
      stream_uri_hd: "http://www.radioking.com/play/radio-wcs/122563"
    }

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Poison.encode!(list))
  end
end
