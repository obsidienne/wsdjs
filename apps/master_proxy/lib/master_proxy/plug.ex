defmodule MasterProxy.Plug do
  def init(options) do
    options
  end

  def call(conn, _opts) do
    cond do
      true ->
        Wsdjs.Endpoint.call(conn, [])
    end
  end
end
