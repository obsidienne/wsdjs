defmodule WsdjsWeb.UserController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, _current_user) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => user_id}, _current_user) do
    user = Accounts.get_user!(user_id)
    user = Accounts.load_user_profil(user)

    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}, _current_user) do
    user = Accounts.get_user!(id)

    changeset = Accounts.change_user(user)

    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}, current_user) do
    user = Accounts.get_user!(id)

    with {:ok, _} <- Accounts.update_user(user, user_params, current_user) do
      conn
      |> put_flash(:info, "Profil updated.")
      |> redirect(to: Routes.user_path(conn, :show, user))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end
end
