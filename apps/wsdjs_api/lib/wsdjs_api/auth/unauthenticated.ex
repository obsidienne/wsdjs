defmodule WsdjsApi.Unauthenticated do
  @moduledoc false
  use WsdjsApi, :controller

  def call(conn, _params) do
    conn
    |> put_status(401)
    |> json(%{errors: %{detail: "Unauthenticated"}})
    |> halt()
  end
end
