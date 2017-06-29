defmodule Wsdjs.Web.UserController do
  use Wsdjs.Web, :controller

  def index(conn, _params) do
    users = Wsdjs.Accounts.list_users()

    render conn, "index.html", users: users
  end

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def show(conn, %{"id" => id}) do
    user = Wsdjs.Accounts.get_user!(id)
    
    page = Wsdjs.Musics.paginate_songs_user(user)
    
    conn
    |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
    |> put_resp_header("page-number", Integer.to_string(page.page_number))
    |> render("show.html", user: user, songs: page.entries, page_number: page.page_number, total_pages: page.total_pages)
  end

  @doc """
  Authz needed
  """
  def edit(conn, %{"id" => id}) do
    user = Wsdjs.Accounts.get_user!(id)
    changeset = Wsdjs.Accounts.change_user(user)
    render conn, "edit.html", user: user, changeset: changeset
  end

  @doc """
  Authz needed
  """
  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Wsdjs.Accounts.get_user!(id)

    case Wsdjs.Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Profile updated.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

end
