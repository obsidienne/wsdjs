defmodule WsdjsWeb.Api.V1.AccountController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

  action_fallback WsdjsWeb.Api.V1.FallbackController

  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    with %User{} = user <- Accounts.get_user!(id),
         :ok <- Accounts.Policy.can?(current_user, :show, user) do
      render(conn, "show.json", user: user)
    end
  end

  def show(conn, %{}) do
    current_user = conn.assigns[:current_user]

    with %User{} = user <- Accounts.get_user!(current_user.id),
         :ok <- Accounts.Policy.can?(current_user, :show, user) do

      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = conn.assigns[:current_user]

    with user <- Accounts.get_user!(id),
         :ok <- Accounts.Policy.can?(current_user, :edit_user, user),
         {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do

      render(conn, "show.json", user: user)
    end
  end
end
