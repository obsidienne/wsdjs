defmodule WsdjsApi.StaticController do
  @moduledoc false
  use WsdjsWeb, :controller

  def show(conn, params) do
    render(conn, "show.json", params)
  end
end
