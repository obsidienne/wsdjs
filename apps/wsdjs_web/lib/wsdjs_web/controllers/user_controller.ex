defmodule Wsdjs.Web.UserController do
  use Wsdjs.Web, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Musics

  @doc false
  def index(conn, _params) do
    users = Accounts.list_users()
    render conn, "index.html", users: users
  end

  @doc false
  def show(conn, %{"id" => user_id}) do
    current_user = conn.assigns[:current_user]
    user = Accounts.get_user!(user_id)
    
    page = Musics.paginate_songs_user(current_user, user_id)

    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render("show.html", user: user, songs: page.entries, page_number: page.page_number, total_pages: page.total_pages, total_songs: page.total_entries)
  end

  @doc false
  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render conn, "edit.html", user: user, changeset: changeset
  end


  @doc false
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile updated.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end
end
