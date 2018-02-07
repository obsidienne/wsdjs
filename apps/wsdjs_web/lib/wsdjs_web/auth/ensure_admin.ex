defmodule WsdjsWeb.EnsureAdmin do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    handler_fn = Keyword.get(opts, :handler_fn)

    case conn.assigns[:current_user] do
      %{admin: true} ->
        conn

      _ ->
        conn = conn |> halt
        apply(WsdjsWeb.Unauthenticated, handler_fn, [conn, conn.params])
    end
  end
end
