defmodule WsdjsWeb.Admin.UserController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts

  def index(conn, _params) do
    users = Accounts.list_users()
    invitations = Accounts.list_invitations()
    render conn, "index.html", users: users, invitations: invitations
  end
end
