defmodule WsdjsWeb.UserController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    users = Wcsp.users()

    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Wcsp.find_user!(id: id)
    render conn, "show.html", user: user
  end
end
