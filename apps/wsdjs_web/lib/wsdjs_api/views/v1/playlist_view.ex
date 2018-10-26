defmodule WsdjsApi.V1.PlaylistView do
  use WsdjsApi, :view
  alias WsdjsApi.V1.PlaylistView

  def render("index.json", %{playlists: playlists}) do
    %{
      data: render_many(playlists, PlaylistView, "playlist.json")
    }
  end

  def render("show.json", %{playlist: playlist}) do
    %{
      data: render_one(playlist, PlaylistView, "playlist.json")
    }
  end

  def render("playlist.json", %{playlist: playlist}) do
    %{
      id: playlist.id,
      name: playlist.name
    }
  end
end
