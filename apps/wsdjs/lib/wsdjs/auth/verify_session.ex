defmodule Wsdjs.VerifySession do
  import Plug.Conn

  def init([]), do: []

  def call(%{assigns: %{current_user: %{}}} = conn, _opts), do: conn
  def call(conn, _repo) do
    id = get_session(conn, :user_id)
    user = if id, do: Wcsp.find_user!(id: id)

    conn
    |> assign(:current_user, user)
  end
end
