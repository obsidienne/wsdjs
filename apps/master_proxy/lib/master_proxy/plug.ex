defmodule MasterProxy.Plug do
  def init(options) do
    options
  end

  def call(conn, _opts) do
    cond do
      conn.request_path =~ ~r{/api} ->
        WsdjsApi.Endpoint.call(conn, [])
      true ->
        WsdjsWeb.Endpoint.call(conn, [])
    end
  end
end