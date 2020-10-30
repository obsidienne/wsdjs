defmodule WsdjsWeb.UserParamsController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts

  action_fallback(WsdjsWeb.FallbackController)

  def show(conn, %{"id" => user_id}) do
    user = Accounts.get_user!(user_id)

    changeset = Accounts.change_user(user)
    user = Accounts.load_user_profil(user)

    render(
      conn,
      "show.html",
      user: user,
      changeset: changeset
    )
  end
end
