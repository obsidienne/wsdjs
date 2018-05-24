defmodule WsdjsWeb.RadioController do
  @moduledoc false

  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  def show(conn, _params, current_user) do
    render(conn, "show.html")
  end
end