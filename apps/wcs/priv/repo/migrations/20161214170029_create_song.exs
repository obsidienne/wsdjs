defmodule Dj.Repo.Migrations.CreateSong do
  use Ecto.Migration

  def up do
    create table(:songs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :artist, :string, null: false
      add :url, :string, null: false
      add :bpm, :integer, null: false, default: 0
      add :genre, :string, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :photo_id, references(:photos, on_delete: :nothing, type: :binary_id), null: false

      timestamps
    end

    create unique_index(:songs, [:title, :artist])
  end

  def down do
    drop table(:songs)
  end
end
