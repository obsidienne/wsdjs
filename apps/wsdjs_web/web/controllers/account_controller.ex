defmodule WsdjsWeb.AccountController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    accounts = Wcsp.User.accounts()

    render conn, "index.html", accounts: accounts
  end

  def show(conn, %{"id" => id}) do
    account = Wcsp.User.find_account!(id: id)
    render conn, "show.html", account: account
  end
end
