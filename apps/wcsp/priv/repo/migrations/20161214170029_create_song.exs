defmodule Dj.Repo.Migrations.CreateSong do
  use Ecto.Migration

  def up do
    create table(:songs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :artist, :string, null: false
      add :url, :string
      add :bpm, :integer, null: false, default: 0
      add :genre, :string, null: false

      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id), null: false

      timestamps
    end

    create unique_index(:songs, [:title, :artist])
  end

  def down do
    drop table(:songs)
  end
end
