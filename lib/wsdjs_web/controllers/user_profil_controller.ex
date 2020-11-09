defmodule WsdjsWeb.UserProfilController do
  @moduledoc false

  use WsdjsWeb, :controller

  alias Wsdjs.Accounts

  def edit(conn, _params) do
    user_profil = get_current_user_profil(conn)
    changeset = Accounts.change_user_profil(user_profil)
    render(conn, "edit.html", user_profil: user_profil, changeset: changeset)
  end

  def update(conn, %{"user_profil" => user_profil_params}) do
    user_profil = get_current_user_profil(conn)

    case Accounts.update_user_profil(user_profil, user_profil_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "User profil updated")
        |> redirect(to: Routes.user_profil_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, user_profil: user_profil)
    end
  end

  defp get_current_user_profil(conn) do
    user = conn.assigns.current_user
    Accounts.get_profil_by_user(user)
  end
end
