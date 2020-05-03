defmodule WsdjsWeb.UserParamsController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  @spec show(Plug.Conn.t(), map(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def show(conn, %{"id" => user_id}, current_user) do
    user = Accounts.get_user!(user_id)

    with :ok <- Accounts.Users.can?(current_user, :edit_user, user) do
      changeset = Accounts.change_user(user)

      conn
      |> render(
        "show.html",
        user: user,
        changeset: changeset
      )
    end
  end
end
