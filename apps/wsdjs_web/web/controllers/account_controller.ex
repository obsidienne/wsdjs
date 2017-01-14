defmodule WsdjsWeb.AccountController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    accounts = Wcsp.User.accounts()

    render conn, "index.html", accounts: accounts
  end

  def show(conn, params) do
    render conn, "show.html"
  end
end
