defmodule WsdjsWeb.Unauthenticated do
  @moduledoc false
  use WsdjsWeb, :controller

  def session_call(conn, _params) do
    conn
    |> put_flash(:error, "You must be logged in to access that page")
    |> redirect(to: session_path(conn, :new))
    |> halt()
  end

  def admin_call(conn, _params) do
    conn
    |> put_flash(:error, "You must be an admin to access that page")
    |> redirect(to: home_path(conn, :index))
    |> halt()
  end
end
