defmodule Wsdjs.Repo.Migrations.ChangeIndex do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE playlists DROP CONSTRAINT playlists_song_id_fkey"

    alter table(:playlists) do
      modify(:song_id, references(:songs, type: :uuid, on_delete: :delete_all))
    end
  end

  def down do
    execute "ALTER TABLE playlists DROP CONSTRAINT playlists_song_id_fkey"

    alter table(:playlists) do
      modify(:song_id, references(:songs, type: :uuid, on_delete: :nothing))
    end
  end
end
