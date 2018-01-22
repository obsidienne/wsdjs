defmodule WsdjsWeb.UserController do
  @moduledoc false
  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

  action_fallback WsdjsWeb.FallbackController

  def show(conn, %{"id" => user_id}, current_user) do
    with %User{} = user <- Accounts.get_user!(user_id),
        :ok <- Accounts.Policy.can?(current_user, :show, user) do

      suggested_songs = Wsdjs.Musics.count_suggested_songs(user)
      playlists = Wsdjs.Playlists.list_playlists(user)

      conn
      |> render("show.html", user: user, suggested_songs: suggested_songs, playlists: playlists)
    end
  end

  def edit(conn, %{"id" => id}, current_user) do
    with %User{} = user <- Accounts.get_user!(id),
         :ok <- Accounts.Policy.can?(current_user, :edit_user, user) do
      changeset = Accounts.change_user(user)
      render conn, "edit.html", user: user, changeset: changeset
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}, current_user) do
    with %User{} = user <- Accounts.get_user!(id),
         :ok <- Accounts.Policy.can?(current_user, :edit_user, user),
         {:ok, user} <- Accounts.update_user(user, user_params, current_user) do

      conn
      |> put_flash(:info, "Profile updated.")
      |> redirect(to: user_path(conn, :show, user))
    end
  end
end
