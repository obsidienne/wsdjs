defmodule WsdjsWeb.PlaylistController do
  use WsdjsWeb, :controller

  alias Wsdjs.Playlists
  alias Wsdjs.Accounts

  action_fallback WsdjsWeb.FallbackController

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"user_id" => user_id}, current_user) do
    with %Accounts.User{} = user <- Accounts.get_user!(user_id),
         playlists <- Playlists.list_playlists(user) do

      render conn, "index.html", playlists: playlists
    end
  end

  def new(conn, _params, current_user) do
    with :ok <- Playlists.Policy.can?(current_user, :new),
         changeset <- Playlists.change_playlist(%Playlists.Playlist{}) do
  
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{"playlist" => playlist_params, "user_id" => user_id}, current_user) do
    playlist_params = Map.put(playlist_params, "user_id", user_id)
    case Playlists.create_playlist(playlist_params) do
      {:ok, playlist} ->
        conn
        |> put_flash(:info, "Playlist created successfully.")
        |> redirect(to: playlist_path(conn, :show, playlist))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    with playlist <- Playlists.get_playlist!(id),
        :ok <- Playlists.Policy.can?(current_user, :show, playlist),
        songs <- Playlists.list_playlist_songs(playlist) do
      
      render conn, "show.html", playlist: playlist, songs: songs, current_user: current_user
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    with %Playlists.Playlist{} = playlist <- Playlists.get_playlist!(id),
         :ok <- Playlists.Policy.can?(current_user, :delete, playlist),
         {:ok, _} = Playlists.delete_playlist(playlist) do

      conn
      |> put_flash(:info, "playlist deleted successfully.")
      |> redirect(to: user_playlist_path(conn, :index, current_user))
    end
  end
end
