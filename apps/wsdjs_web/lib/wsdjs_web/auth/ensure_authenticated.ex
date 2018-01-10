defmodule WsdjsWeb.EnsureAuthenticated do
  @moduledoc """
    plug PhoenixTokenPlug.EnsureAuthenticated,
      handler_fn: :handle_error      # (required) Customize the handler function
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    case conn.assigns[:current_user] do
      nil ->
        conn = conn |> halt
        apply(WsdjsWeb.Unauthenticated, :session_call, [conn, conn.params])
      _ ->
        conn
    end
  end

end
