defmodule WsdjsApi.AccountController do
  @moduledoc false
  use WsdjsApi, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

  action_fallback(WsdjsApi.V1.FallbackController)

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(id)

    with :ok <- Accounts.Users.can?(current_user, :show, user) do
      render(conn, "show.json", user: user)
    end
  end

  def show(conn, %{}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(current_user.id)

    with :ok <- Accounts.Users.can?(current_user, :show, user) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(id)

    with :ok <- Accounts.Users.can?(current_user, :edit_user, user),
         {:ok, %User{} = user} <- Accounts.update_user(user, user_params, current_user) do
      render(conn, "show.json", user: user)
    end
  end
end
