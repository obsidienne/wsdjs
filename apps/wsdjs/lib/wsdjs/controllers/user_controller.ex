defmodule Wsdjs.UserController do
  use Wsdjs, :controller

  def index(conn, _params) do
    users = Wcsp.Account.list_users()

    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    user = Wcsp.find_user_with_songs(current_user, id: id)
    render conn, "show.html", user: user
  end
end
