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

  def create(conn, %{"playlist_id" => playlist_id, "song_id" => song_id}, current_user) when not is_nil(current_user) do
    playlist = Playlists.get_playlist!(playlist_id)
    song = Musics.get_song!(song_id)
    params = %{playlist_id: playlist.id, song_id: song.id, position: 0}

    with :ok <- Playlists.Policy.can?(current_user, :add_song, playlist),
         {:ok, _} <- Playlists.create_playlist_song(params) do
      conn
      |> put_flash(:info, "Song added successfully.")
      |> redirect(to: playlist_path(conn, :show, playlist))
    end
  end
end
