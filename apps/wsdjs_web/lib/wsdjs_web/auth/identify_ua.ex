defmodule WsdjsWeb.IdentifyUa do
  import Plug.Conn

  @doc false
  def init([]), do: []

  @doc false
  def call(conn, _repo) do
    conn
    |> assign(:layout_type, device_type(conn))
    |> Phoenix.Controller.put_layout(layout_type(conn))
  end

  def layout_type(%Plug.Conn{} = conn) do
    if device_type(conn) == "mobile" do
      {WsdjsWeb.LayoutView, :"mobile-app"}
    else
      {WsdjsWeb.LayoutView, :app}
    end
  end

  def device_type(%Plug.Conn{} = conn) do
    ua = get_req_header(conn, "user-agent")
    device_type(ua)
  end
  def device_type([ua|_]), do: device_type(ua)
  def device_type([]), do: "desktop"
  def device_type(ua) when is_binary(ua) do
    parsed = UAInspector.parse(ua)
    case parsed.device do
      %{type: "smartphone"} -> "mobile"
      _ -> "desktop"
    end
  end
end
