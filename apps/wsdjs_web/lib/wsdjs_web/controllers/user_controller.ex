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

  def edit(conn, %{"id" => id}) do
    user = Wsdjs.Accounts.get_user!(id)
    changeset = Wsdjs.Accounts.change_user(user)    
    render conn, "edit.html", user: user, changeset: changeset
  end

  def update(conn, %{"id" => id, "user" => %{
    "description" => description, 
    "djname" => djname,
    "name" => name,
    "user_country" => user_country,
    "email" => email,
    "cl_version" => cl_version,
    "cl_public_id" => cl_public_id 
    }}) do
    params = %{
      "description" => description, 
      "djname" => djname,
      "name" => name,
      "user_country" => user_country,
      "email" => email
    }
    current_user = conn.assigns[:current_user]
    avatar_params = %{
      "cld_id" => cl_public_id,
      "version" => cl_version
    }

    changeset = Wsdjs.Accounts.User.changeset(current_user, params)
    IO.inspect cl_version
    cl_version_length = String.length cl_version
    cl_public_id_length = String.length cl_public_id
    if cl_version_length > 0 && cl_public_id_length > 0 do
      cl_version_integer = String.to_integer cl_version
      avatar = Ecto.Changeset.change(%Wsdjs.Accounts.Avatar{}, cld_id: cl_public_id, version: cl_version_integer)    
      changeset = Ecto.Changeset.put_assoc(changeset, :avatar, avatar)
    end
    
    case Wsdjs.Repo.update(changeset) do
      {:ok, user} ->
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
