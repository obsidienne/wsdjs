defmodule WsdjsWeb.Api.V1.AccountController do
  @moduledoc false
  use WsdjsWeb, :controller

  plug :put_layout, "login.html"

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

  action_fallback WsdjsWeb.Api.V1.FallbackController

  def show(conn, %{"id" => id}) do
    with user <- Accounts.get_user!(id) do
      render(conn, "show.json", user: user)
    end
  end

  def show(conn, %{}) do
    current_user = conn.assigns[:current_user]

    with user <- Accounts.get_user!(current_user.id) do
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user(id)

    with :ok <- Accounts.Policy.can?(current_user, :edit_user, user),
        {:ok, user} <- Accounts.update_user(user, user_params) do
      [avatar] = Accounts.get_avatar(user)
      render(conn, "show.json", user: user, avatar: avatar)
    end
  end
end
