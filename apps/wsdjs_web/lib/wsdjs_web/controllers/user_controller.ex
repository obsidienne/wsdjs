defmodule WsdjsWeb.UserController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Musics

  action_fallback WsdjsWeb.FallbackController

  def show(conn, %{"id" => user_id}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user(user_id)

    with :ok <- Accounts.Policy.can?(:show_user, user, current_user) do
      page = Musics.paginate_songs_user(current_user, user_id)

      conn
      |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
      |> put_resp_header("page-number", Integer.to_string(page.page_number))
      |> render("show.html", user: user, songs: page.entries, page_number: page.page_number, total_pages: page.total_pages, total_songs: page.total_entries)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    with user = Accounts.get_user(id),
         :ok <- Accounts.Policy.can?(:edit_user, user, current_user) do
      changeset = Accounts.change_user(user)
      render conn, "edit.html", user: user, changeset: changeset
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user(id)

    with :ok <- Accounts.Policy.can?(:edit_user, user, current_user),
         {:ok, user} <- Accounts.update_user(user, user_params) do
      conn
      |> put_flash(:info, "Profile updated.")
      |> redirect(to: user_path(conn, :show, user))
    else
      false ->
        conn
        |> put_flash(:error, "You can't update this user.")
        |> redirect(to: home_path(conn, :index))
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(:error, "Invalide modifications.")
        |> render("edit.html", user: user, changeset: changeset)
    end
  end
end
