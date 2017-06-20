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

  @countries ["EN", "FR", "US"]

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]
    user = Wcsp.Accounts.get_user!(id)
    changeset = Wcsp.Accounts.User.changeset(%Wcsp.Accounts.User{})
    countries = @countries
    render conn, "edit.html", user: user, changeset: changeset, countries: countries
  end

  def update(conn, %{"id" => id, "user" => params}) do
    current_user = conn.assigns[:current_user]
    changeset = Wcsp.Accounts.User.changeset(current_user, params)
    case Wcsp.Repo.update(changeset) do
      {:ok, user} -> 
        IO.inspect user
        conn        
        |> put_flash(:info, "Profile updated")
        |> redirect(to: user_path(conn, :show, current_user))
      _ -> 
        conn
        |> put_flash(:error, "Something went wrong !")
        |> redirect(to: user_path(conn, :edit, current_user))
    end
  end

end
