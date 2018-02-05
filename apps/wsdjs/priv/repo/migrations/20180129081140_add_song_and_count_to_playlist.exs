defmodule Wsdjs.Repo.Migrations.AddSongAndCountToPlaylist do
  use Ecto.Migration
  import Ecto.Query, warn: false

  def up do
    alter table(:playlists) do
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id)
      add :count, :int, default: 0, null: false
    end
  end

  def down do
    alter table(:playlists) do
      remove :song_id
      remove :count
    end
  end
end
