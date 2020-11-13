defmodule WsdjsWeb.AdminAuth do
  import Plug.Conn

  import Phoenix.Controller
  alias Wsdjs.Accounts
  alias WsdjsWeb.Router.Helpers, as: Routes

  def require_authenticated_admin(conn, _opts) do
    if conn.assigns[:current_user] && Accounts.user_is_admin(conn.assigns[:current_user]) do
      conn
    else
      conn
      |> put_flash(:error, "You must be an admin to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: Routes.user_session_path(conn, :new))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    %{request_path: request_path, query_string: query_string} = conn
    return_to = if query_string == "", do: request_path, else: request_path <> "?" <> query_string
    put_session(conn, :user_return_to, return_to)
  end

  defp maybe_store_return_to(conn), do: conn
end
