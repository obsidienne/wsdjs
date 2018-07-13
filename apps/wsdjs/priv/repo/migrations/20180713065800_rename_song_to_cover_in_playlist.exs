defmodule Wsdjs.Repo.Migrations.RenameSongToCoverInPlaylist do
  use Ecto.Migration

  def change do
    rename(table("playlists"), :song_id, to: :cover_id)
  end
end
