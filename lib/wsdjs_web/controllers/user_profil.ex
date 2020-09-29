defmodule WsdjsWeb.UserProfil do
  import Plug.Conn
  import Phoenix.Controller

  alias Wsdjs.Accounts
  alias WsdjsWeb.Router.Helpers, as: Routes

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """
  def fetch_current_user_profil(conn, _opts) do
    user = conn.assigns[:current_user]
    profil = user && Accounts.get_profil_by_user(user)
    assign(conn, :current_profil, profil)
  end
end
