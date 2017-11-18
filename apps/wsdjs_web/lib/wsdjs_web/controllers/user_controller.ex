defmodule WsdjsWeb.UserController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics

  action_fallback WsdjsWeb.FallbackController

  def show(conn, %{"id" => user_id}) do
    current_user = conn.assigns[:current_user]

    with %User{} = user <- Accounts.get_user!(user_id),
        :ok <- Accounts.Policy.can?(current_user, :show, user) do
      page = Musics.paginate_songs_user(current_user, user_id)

      conn
      |> put_resp_header("total-pages", Integer.to_string(page.total_pages))
      |> put_resp_header("page-number", Integer.to_string(page.page_number))
      |> render("show.html", user: user, songs: page.entries, page_number: page.page_number, total_pages: page.total_pages, total_songs: page.total_entries)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    with %User{} = user <- Accounts.get_user!(id),
         :ok <- Accounts.Policy.can?(current_user, :edit_user, user) do
      changeset = Accounts.change_user(user)
      render conn, "edit.html", user: user, changeset: changeset
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = conn.assigns[:current_user]

    with %User{} = user <- Accounts.get_user!(id),
         :ok <- Accounts.Policy.can?(current_user, :edit_user, user),
         {:ok, user} <- Accounts.update_user(user, user_params, current_user) do

      conn
      |> put_flash(:info, "Profile updated.")
      |> redirect(to: user_path(conn, :show, user))
    end
  end
end
