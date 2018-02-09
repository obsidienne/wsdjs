defmodule WsdjsWeb.PlaylistController do
  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Playlists
  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

  action_fallback WsdjsWeb.FallbackController

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
    user = Accounts.get_user!(user_id)
    playlist_params = Map.put(playlist_params, "user_id", user_id)

    with :ok <- Playlists.Policy.can?(current_user, :create, user),
         {:ok, playlist} <- Playlists.create_playlist(playlist_params) do

      conn
      |> put_flash(:info, "Playlist created successfully.")
      |> redirect(to: user_path(conn, :show, user, [playlist: playlist]))
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    playlist = Playlists.get_playlist!(id, current_user)
    user = Accounts.get_user!(playlist.user_id)

    with :ok <- Playlists.Policy.can?(current_user, :delete, playlist),
         {:ok, _} = Playlists.delete_playlist(playlist) do

      conn
      |> put_flash(:info, "playlist deleted successfully.")
      |> redirect(to: user_path(conn, :show, user))
    end
  end
end
