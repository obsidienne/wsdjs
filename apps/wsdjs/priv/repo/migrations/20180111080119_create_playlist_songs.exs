defmodule Wsdjs.Repo.Migrations.CreatePlaylistSongs do
  use Ecto.Migration

  def up do
    create table(:playlist_songs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :position, :integer, null: false, default: 0

      add :playlist_id, references(:playlists, on_delete: :nothing, type: :binary_id), null: false
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false

      timestamps(updated_at: false)
    end

    create unique_index(:playlist_songs, [:playlist_id, :song_id])
  end

  def down do
    drop table(:playlist_songs)
  end

end
