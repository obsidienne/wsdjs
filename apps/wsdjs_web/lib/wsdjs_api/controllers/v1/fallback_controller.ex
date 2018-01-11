defmodule WsdjsApi.V1.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WsdjsWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(WsdjsApi.V1.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, {:error, :invalid}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(WsdjsApi.V1.ErrorView, :"422")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> render(WsdjsApi.V1.ErrorView, :"401")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> render(WsdjsApi.V1.ErrorView, :"404")
  end
end
