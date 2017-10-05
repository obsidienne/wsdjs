defmodule WsdjsWeb.IdentifyUa do
  import Plug.Conn

  @doc false
  def init([]), do: []

  @doc false
  def call(conn, _repo) do
    conn
    |> assign(:layout_type, is_mobile(conn))
    |> Phoenix.Controller.put_layout(layout_type(conn))
  end

  def layout_type(%Plug.Conn{} = conn) do
    if is_mobile(conn) == "mobile" do
      {WsdjsWeb.LayoutView, :"mobile-app"}
    else
      {WsdjsWeb.LayoutView, :app}
    end
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
