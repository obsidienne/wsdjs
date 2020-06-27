defmodule WsdjsWeb.Api.AccountController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User
  alias Wsdjs.Profils

  action_fallback(WsdjsWeb.Api.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def show(conn, %{"id" => id}, current_user) do
    user = Accounts.get_user!(id)

    with :ok <- Profils.can?(current_user, :show, user) do
      render(conn, "show.json", user: user)
    end
  end

  def show(conn, %{}, current_user) do
    with :ok <- Profils.can?(current_user, :show, current_user) do
      render(conn, "show.json", user: current_user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, current_user) do
    user = Accounts.get_user!(id)

    with :ok <- Profils.can?(current_user, :edit_user, user),
         {:ok, %User{} = user} <- Accounts.update_user(user, user_params, current_user) do
      render(conn, "show.json", user: user)
    end
  end
end
