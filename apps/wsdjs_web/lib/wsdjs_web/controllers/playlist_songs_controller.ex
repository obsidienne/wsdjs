defmodule WsdjsWeb.PlaylistSongsController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Playlists
  alias Wsdjs.Musics

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, %{"playlist_id" => playlist_id, "song_id" => song_id}, current_user)
      when not is_nil(current_user) do
    playlist = Playlists.get_playlist!(playlist_id)
    song = Musics.get_song!(song_id)
    params = %{playlist_id: playlist.id, song_id: song.id, position: 0}

    with :ok <- Playlists.Policy.can?(current_user, :add_song, playlist),
         {:ok, _} <- Playlists.create_playlist_song(params) do
      conn
      |> put_flash(:info, "Song added successfully.")
      |> redirect(to: playlist_path(conn, :show, playlist))
    else
      {:error, %Ecto.Changeset{}} ->
        conn
        |> put_flash(:error, "Song already added.")
        |> redirect(to: playlist_path(conn, :show, playlist))

      {:error, val} ->
        {:error, val}
    end
  end

  def update(conn, %{"playlist_id" => playlist_id} = params, _current_user) do
    IO.inspect(params)
    playlist = Playlists.get_playlist!(playlist_id)
    redirect(conn, to: playlist_path(conn, :show, playlist))
  end

  @spec delete(Plug.Conn.t(), %{id: String.t()}, Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def delete(conn, %{"playlist_id" => playlist_id, "id" => song_id}, current_user) do
    playlist = Playlists.get_playlist!(playlist_id)
    playlist_song = Playlists.get_playlist_song!(playlist_id, song_id)

    with :ok <- Playlists.Policy.can?(current_user, :delete_song, playlist),
         {:ok, _song} = Playlists.delete_playlist_song(playlist_song) do
      conn
      |> put_flash(:info, "Song deleted successfully.")
      |> redirect(to: playlist_path(conn, :show, playlist))
    end
  end
end
