defmodule WsdjsWeb.VerifySession do
  @moduledoc """
    This modules aims to authenticate the user in case of web browsing.
    We use the session to retrieve the user id and load the corresponding %User{} in conn.
  """
  import Plug.Conn

  @doc false
  def init([]), do: []

  @doc false
  def call(%{assigns: %{current_user: %{}}} = conn, _opts), do: conn
  def call(conn, _repo) do
    id = get_session(conn, :user_id)
    user = if id, do: Wsdjs.Accounts.get_user!(id)

    conn
    |> assign(:current_user, user)
  end
end
