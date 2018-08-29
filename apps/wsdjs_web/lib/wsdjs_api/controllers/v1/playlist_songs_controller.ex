defmodule WsdjsApi.V1.PlaylistSongsController do
  @moduledoc false
  use WsdjsWeb, :controller
  use WsdjsApi.V1.Controller

  alias Wsdjs.Playlists
  alias Wsdjs.Musics

  action_fallback(WsdjsApi.V1.FallbackController)

  def create(conn, %{"playlist_id" => playlist_id, "song_id" => song_id}, current_user)
      when not is_nil(current_user) do
    playlist = Playlists.get_playlist!(playlist_id)
    song = Musics.get_song!(song_id)
    params = %{playlist_id: playlist.id, song_id: song.id, position: 0}

    with :ok <- Playlists.Policy.can?(current_user, :add_song, playlist),
         {:ok, _} <- Playlists.create_playlist_song(params) do
      conn
      |> put_status(:created)
      |> send_resp(:no_content, "")
    end
  end
end
