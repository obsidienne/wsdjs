defmodule WsdjsApi.V1.PlaylistSongsController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Playlists
  alias Wsdjs.Musics

  action_fallback(WsdjsApi.V1.FallbackController)

  def create(conn, %{"playlist_id" => playlist_id, "song_id" => song_id}) do
    current_user = conn.assigns[:current_user]

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
