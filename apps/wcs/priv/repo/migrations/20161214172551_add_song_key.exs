defmodule Photo.Repo.Migrations.AddSongKey do
  use Ecto.Migration

  def up do
    alter table(:photos) do
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false
    end
  end

  def down do
    alter table(:photos) do
      remove :song_id
    end
  end
end
