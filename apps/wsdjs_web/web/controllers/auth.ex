defmodule WsdjsWeb.Auth do
  import Plug.Conn

  def init([]), do: []

  def call(%{assigns: %{current_user: %{}}} = conn, _opts), do: conn
  def call(conn, _repo) do
    id = get_session(conn, :user_id)
    user = if id, do: Wcsp.find_user!(id: id)

    conn
    |> assign(:current_user, user)
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def login_by_email(conn, email, _opts) do
    user = if email, do: Wcsp.find_user(email: email)

    cond do
      user ->
        {:ok, login(conn, user)}
      true ->
        {:error, :not_found, conn}
    end
  end
end
