defmodule WsdjsApi.EnsureAuthenticated do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn = conn |> halt
        apply(WsdjsApi.Unauthenticated, :api_call, [conn, conn.params])

      _ ->
        conn
    end
  end
end
