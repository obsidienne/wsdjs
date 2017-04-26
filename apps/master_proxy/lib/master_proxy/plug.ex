defmodule MasterProxy.Plug do
  def init(options) do
    options
  end

  def call(conn, _opts) do
    cond do
      conn.host =~ ~r/^api\./ ->
        WsdjsApi.Web.Endpoint.call(conn, [])
      true ->
        Wsdjs.Endpoint.call(conn, [])
    end
  end
end
