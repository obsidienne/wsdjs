defmodule WsdjsWeb.Admin.UserController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    users = Accounts.list_users()
    invitations = Accounts.list_invitations(current_user)
    render conn, "index.html", users: users, invitations: invitations
  end
end
