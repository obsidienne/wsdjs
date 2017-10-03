defmodule WsdjsWeb.IdentifyUa do
  import Plug.Conn

  @doc false
  def init([]), do: []

  @doc false
  def call(conn, _repo) do
    [ua] = get_req_header(conn, "user-agent")
    parsed = UAInspector.parse(ua)

    case parsed.device do
      %{type: "smartphone"} ->
        assign(conn, :layout_type, "mobile")
      _ ->
        assign(conn, :layout_type, "desktop")
    end
  end
end
