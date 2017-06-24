defmodule Wsdjs.Repo.Migrations.ChangeForeignKeyOnSong do
  use Ecto.Migration

  def change do
    drop constraint(:arts, "album_arts_song_id_fkey")
    drop constraint(:comments, "comments_song_id_fkey")
    drop constraint(:opinions, "song_opinions_song_id_fkey")

    execute "ALTER TABLE arts ADD FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE;"
    execute "ALTER TABLE comments ADD FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE;"
    execute "ALTER TABLE opinions ADD FOREIGN KEY (song_id) REFERENCES songs(id) ON DELETE CASCADE;"
  end
end
