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
    current_user = conn.assigns[:current_user]
    user = Wsdjs.Accounts.get_user!(id)
    songs = Wsdjs.Musics.list_songs(current_user, user)
    render conn, "show.html", user: user, songs: songs
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
