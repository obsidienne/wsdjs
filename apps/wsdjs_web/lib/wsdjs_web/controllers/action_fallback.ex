defmodule Wsdjs.Web.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use Wsdjs.Web, :controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(Wsdjs.Web.ErrorView, :"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_flash(:error, "Unauthorized action.")
    |> redirect(to: home_path(conn, :index))
  end

  def call(conn, {:error, changeset}) do
    IO.inspect conn
    render(conn, "new.html", changeset: changeset)
  end
end
