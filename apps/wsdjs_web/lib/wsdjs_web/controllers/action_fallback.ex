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

  def call(conn, {:error, :NoResultsError}) do
    conn
    |> put_flash(:error, "Not found.")
    |> redirect(to: Routes.home_path(conn, :index))
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_flash(:error, "Unauthorized action.")
    |> redirect(to: Routes.home_path(conn, :index))
  end

  def call(conn, {:error, changeset}) do
    conn
    |> put_flash(:error, "Something went wrong !")
    |> render("new.html", changeset: changeset)
  end
end
