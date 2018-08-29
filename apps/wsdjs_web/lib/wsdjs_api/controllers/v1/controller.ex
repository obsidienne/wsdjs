defmodule WsdjsApi.V1.Controller do
  @doc """
  This module contains helpers for controller.
  It overwrites the __action__ calling adding the current user stored in conn by the auth plug
  """
  defmacro __using__(_) do
    quote do
      def action(conn, _), do: WsdjsApi.V1.Controller.__action__(__MODULE__, conn)
      defoverridable action: 2
    end
  end

  def __action__(controller, conn) do
    args = [conn, conn.params, conn.assigns[:current_user] || nil]
    apply(controller, Phoenix.Controller.action_name(conn), args)
  end
end
