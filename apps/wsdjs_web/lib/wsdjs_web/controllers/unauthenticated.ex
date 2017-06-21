defmodule Wsdjs.Web.Unauthenticated do
  use Wsdjs.Web, :controller

  def api_call(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{error: "Unauthenticated!"})
    |> halt()
  end

  def session_call(conn, _params) do
    conn
    |> put_flash(:error, "You must be logged in to access that page")
    |> redirect(to: session_path(conn, :new))
    |> halt()
  end
end
