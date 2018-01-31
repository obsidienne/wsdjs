defmodule WsdjsWeb.PlaylistController do
  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Playlists
  alias Wsdjs.Accounts

  action_fallback WsdjsWeb.FallbackController

  def index(conn, %{"user_id" => user_id}, current_user) do
    with %Accounts.User{} = user <- Accounts.get_user!(user_id),
         playlists <- Playlists.list_playlists(user) do

      render conn, "index.html", playlists: playlists, user: user
    end
  end

  def new(conn, %{"user_id" => user_id}, current_user) do
    with %Accounts.User{} = user <- Accounts.get_user!(user_id),
         :ok <- Playlists.Policy.can?(current_user, :new),
         changeset <- Playlists.change_playlist(%Playlists.Playlist{}) do
  
      render(conn, "new.html", changeset: changeset, user: user)
    end
  end

  @doc """
  Only authorized user can create a playlist for somebody else
  """
  def create(conn, %{"playlist" => playlist_params, "user_id" => user_id}, current_user) do
    with %Accounts.User{} = user <- Accounts.get_user!(user_id),
         :ok <- Playlists.Policy.can?(current_user, :create, user),
         playlist_params <- Map.put(playlist_params, "user_id", user_id),
         {:ok, playlist} <- Playlists.create_playlist(playlist_params) do

      conn
      |> put_flash(:info, "Playlist created successfully.")
      |> redirect(to: user_path(conn, :show, user, [playlist: playlist]))
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
