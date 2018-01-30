defmodule Wsdjs.Repo.Migrations.ChangePlaylistPK do
  use Ecto.Migration

  def change do
    drop table(:playlist_songs)
    drop table(:playlists)

    create table(:playlists) do
      add :name, :string, null: false
      add :type, :string, null: false, default: "playlist"
      add :count, :int, default: 0, null: false
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id)

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end
    create unique_index(:playlists, [:user_id, :name])

    create table(:playlist_songs) do
      add :position, :integer, null: false, default: 0

      add :playlist_id, references(:playlists, on_delete: :nothing), null: false
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false

      timestamps(updated_at: false)
    end

    create unique_index(:playlist_songs, [:playlist_id, :song_id])
  end
end
