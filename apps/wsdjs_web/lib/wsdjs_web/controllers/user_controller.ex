defmodule WsdjsWeb.UserController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    with :ok <- Accounts.Users.can?(current_user, :index) do
      users = Accounts.list_users()
      render(conn, "index.html", users: users)
    end
  end

  def show(conn, %{"id" => user_id}, current_user) do
    user = Accounts.get_user!(user_id)

    with :ok <- Accounts.Users.can?(current_user, :show, user) do
      playlists = Wsdjs.Playlists.list_frontpage_playlist_songs(current_user)

      conn
      |> render(
        "show.html",
        user: user,
        playlists: playlists
      )
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    user = Accounts.get_user!(id)

    with :ok <- Accounts.Users.can?(current_user, :edit_user, user) do
      changeset = Accounts.change_user(user)
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, current_user) do
    user = Accounts.get_user!(id)

    with :ok <- Accounts.Users.can?(current_user, :edit_user, user),
         {:ok, _} <- Accounts.update_user(user, user_params, current_user) do
      conn
      |> put_flash(:info, "Profile updated.")
      |> redirect(to: Routes.user_path(conn, :show, user))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end
end
