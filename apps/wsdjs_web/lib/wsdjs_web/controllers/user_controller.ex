defmodule Wsdjs.Web.UserController do
  @moduledoc false
  use Wsdjs.Web, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Musics

  def index(conn, _params) do
    users = Accounts.list_users()
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => user_id}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(user_id)
    
    page = Musics.paginate_songs_user(current_user, user_id)

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render("show.html", user: user, songs: page.entries, page_number: page.page_number, total_pages: page.total_pages, total_songs: page.total_entries)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render conn, "edit.html", user: user, changeset: changeset
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    current_user = conn.assigns[:current_user]

    with true <- Accounts.Policy.can?(:edit_user, user, current_user),
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
