defmodule WsdjsWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WsdjsWeb, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(WsdjsWeb.ErrorView, :"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_flash(:error, "Unauthorized action.")
    |> redirect(to: home_path(conn, :index))
  end

  def call(conn, {:error, changeset}) do
    render(conn, "new.html", changeset: changeset)
  end
end
