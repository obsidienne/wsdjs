defmodule WsdjsWeb.Api.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use WsdjsWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(WsdjsApi.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(WsdjsApi.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :invalid}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(WsdjsApi.ErrorView)
    |> render(WsdjsApi.V1.ErrorView, :"422")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(WsdjsApi.ErrorView)
    |> render(WsdjsApi.V1.ErrorView, :"401")
  end
end
