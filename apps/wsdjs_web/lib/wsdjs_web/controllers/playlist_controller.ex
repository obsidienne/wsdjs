defmodule WsdjsWeb.PlaylistController do
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts
  alias Wsdjs.Playlists

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"user_id" => user_id}, current_user) do
    with %Accounts.User{} = user <- Accounts.get_user!(user_id) do
      suggested_songs = Wsdjs.Musics.count_suggested_songs(user)
      playlists = Wsdjs.Playlists.list_playlists(user, current_user)

      render(
        conn,
        "index.html",
        user: user,
        suggested_songs: suggested_songs,
        playlists: playlists
      )
    end
  end

  def new(conn, %{"user_id" => user_id}, current_user) do
    user = Accounts.get_user!(user_id)

    with :ok <- Playlists.Policy.can?(current_user, :new),
         changeset <- Playlists.change_playlist(%Playlists.Playlist{}) do
      render(conn, "new.html", changeset: changeset, user: user)
    end
  end

  def show(conn, %{"id" => id}, current_user) do
    playlist = Playlists.get_playlist!(id, current_user)
    user = Accounts.get_user!(playlist.user_id)

    suggested_songs = Wsdjs.Musics.count_suggested_songs(user)
    playlist_songs = Wsdjs.Playlists.list_playlist_songs(playlist, current_user)

    render(
      conn,
      "show.html",
      current_user: current_user,
      playlist: playlist,
      suggested_songs: suggested_songs,
      playlist_songs: playlist_songs,
      user: user
    )
  end

  def edit(conn, %{"id" => id}, current_user) do
    playlist = Playlists.get_playlist!(id)
    user = Accounts.get_user!(playlist.user_id)

    with :ok <- Playlists.Policy.can?(current_user, :edit, playlist) do
      suggested_songs = Wsdjs.Musics.count_suggested_songs(user)
      changeset = Playlists.change_playlist(playlist)

      render(
        conn,
        "edit.html",
        playlist: playlist,
        suggested_songs: suggested_songs,
        changeset: changeset,
        user: user
      )
    end
  end

  def update(conn, %{"id" => id, "playlist" => playlist_params}, current_user) do
    playlist = Playlists.get_playlist!(id)

    with :ok <- Playlists.Policy.can?(current_user, :edit, playlist),
         {:ok, _user} <- Playlists.update_playlist(playlist, playlist_params, current_user) do
      conn
      |> put_flash(:info, "Playlist updated.")
      |> redirect(to: Routes.playlist_path(conn, :show, playlist))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: current_user, changeset: changeset)

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Only authorized user can create a playlist for somebody else
  """
  def create(conn, %{"playlist" => playlist_params, "user_id" => user_id}, current_user) do
    playlist_params = Map.put(playlist_params, "user_id", user_id)

    with :ok <- Playlists.Policy.can?(current_user, :new),
         {:ok, playlist} <- Playlists.create_playlist(playlist_params) do
      conn
      |> put_flash(:info, "Playlist created successfully.")
      |> redirect(to: Routes.playlist_path(conn, :show, playlist))
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    playlist = Playlists.get_playlist!(id)
    user = Accounts.get_user!(playlist.user_id)

    with :ok <- Playlists.Policy.can?(current_user, :delete, playlist),
         {:ok, _} = Playlists.delete_playlist(playlist) do
      conn
      |> put_flash(:info, "playlist deleted successfully.")
      |> redirect(to: Routes.user_path(conn, :show, user))
    end
  end
end
