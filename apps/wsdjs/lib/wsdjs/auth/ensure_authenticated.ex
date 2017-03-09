defmodule Wsdjs.EnsureAuthenticated do
  @moduledoc """
    plug PhoenixTokenPlug.EnsureAuthenticated,
      handler_fn: :handle_error      # (required) Customize the handler function
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    handler_fn = Keyword.get(opts, :handler_fn)
    case conn.assigns[:current_user] do
      nil ->
        conn = conn |> halt
        apply(Wsdjs.Unauthenticated, handler_fn, [conn, conn.params])
      _ ->
        conn
    end
  end

end
