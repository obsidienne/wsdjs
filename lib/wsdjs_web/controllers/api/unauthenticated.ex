defmodule WsdjsWeb.Api.Unauthenticated do
  @moduledoc false
  use WsdjsWeb, :controller

  def call(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{errors: %{detail: "Unauthenticated"}})
    |> halt()
  end
end
