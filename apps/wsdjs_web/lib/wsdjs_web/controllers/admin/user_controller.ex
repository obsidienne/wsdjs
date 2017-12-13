defmodule WsdjsWeb.Admin.UserController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Auth

  def index(conn, _params) do
    users = Accounts.list_users()
    invitations = Auth.list_invitations()
    render conn, "index.html", users: users, invitations: invitations
  end
end
