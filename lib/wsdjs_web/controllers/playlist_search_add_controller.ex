defmodule WsdjsWeb.PlaylistSearchAddController do
  @moduledoc """
  This module does search a song to add it to a playlist
  """
  use WsdjsWeb, :controller

  alias Wsdjs.Playlists

  plug(:put_layout, false)

  def index(conn, %{"playlist_id" => playlist_id, "q" => q}) do
    current_user = conn.assigns.current_user
    songs = Wsdjs.Musics.search(current_user, q)
    playlist = Playlists.get_playlist!(playlist_id)

    render(conn, "index.html", songs: songs, playlist: playlist)
  end
end
