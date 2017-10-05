defmodule WsdjsWeb.IdentifyUa do
  import Plug.Conn

  @doc false
  def init([]), do: []

  @doc false
  def call(conn, _repo) do
    assign(conn, :layout_type, (conn))
  end

  def is_mobile(%Plug.Conn{} = conn) do
    [ua] = get_req_header(conn, "user-agent")
    parsed = UAInspector.parse(ua)
    IO.inspect parsed
    case parsed.device do
      %{type: "smartphone"} -> "mobile"
      _ -> "desktop"
    end
  end
end
