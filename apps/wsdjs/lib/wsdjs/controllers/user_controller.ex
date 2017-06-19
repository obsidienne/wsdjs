defmodule Wsdjs.UserController do
  use Wsdjs, :controller

  def index(conn, _params) do
    users = Wcsp.Accounts.list_users()

    render conn, "index.html", users: users
  end

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def show(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    user = Wcsp.Accounts.get_user!(id)
    songs = Wcsp.Musics.list_songs(current_user, user)
    render conn, "show.html", user: user, songs: songs
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    user = Wcsp.Accounts.get_user!(id)
    changeset = Wcsp.Accounts.User.changeset(%Wcsp.Accounts.User{})
    render conn, "edit.html", user: user, changeset: changeset
  end

  def update(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    
    # top = Wcsp.Trendings.get_top(current_user, id)
    # Wcsp.Trendings.next_step(current_user, top)
    # top = Wcsp.Trendings.get_top(current_user, id)

    redirect(conn, to: user_path(conn, :show, current_user))
  end

end
