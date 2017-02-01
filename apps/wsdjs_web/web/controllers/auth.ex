defmodule WsdjsWeb.Auth do
  import Plug.Conn

  def init([]), do: []

  def call(%{assigns: %{current_user: %{}}} = conn, _opts), do: conn
  def call(conn, repo) do
    id = get_session(conn, :account_id)
    account = if id, do: Wcsp.User.find_account!(id: id)

    conn
    |> assign(:current_user, account)
  end

  def login(conn, account) do
    conn
    |> assign(:current_user, account)
    |> put_session(:account_id, account.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def login_by_email(conn, email, opts) do
    account = if email, do: Wcsp.User.find_account!(email: email)

    cond do
      account ->
        {:ok, login(conn, account)}
      true ->
        {:error, :not_found, conn}
    end
  end
end
