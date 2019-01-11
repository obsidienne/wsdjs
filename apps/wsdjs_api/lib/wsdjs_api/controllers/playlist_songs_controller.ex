defmodule WsdjsApi.PlaylistSongsController do
  @moduledoc false
  use WsdjsApi, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Playlists

  action_fallback(WsdjsApi.V1.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def create(conn, %{"playlist_id" => playlist_id, "song_id" => song_id}, current_user) do
    playlist = Playlists.get_playlist!(playlist_id)
    song = Musics.Songs.get_song!(song_id)
    params = %{playlist_id: playlist.id, song_id: song.id, position: 0}

    with :ok <- Playlists.can?(current_user, :add_song, playlist),
         {:ok, _} <- Playlists.create_playlist_song(params) do
      conn
      |> put_status(:created)
      |> send_resp(:no_content, "")
    end
  end
end
