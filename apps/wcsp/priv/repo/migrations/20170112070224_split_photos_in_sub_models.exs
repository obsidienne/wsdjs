defmodule Wcsp.Repo.Migrations.SplitPhotosInSubModels do
  use Ecto.Migration

  def change do
    create table(:album_arts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cld_id, :string, null: false
      add :version, :integer, null: false
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id), null: false
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create table(:avatars, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cld_id, :string, null: false
      add :version, :integer, null: false
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:album_arts, [:cld_id])
    create unique_index(:avatars, [:cld_id])

    drop table(:photos)
  end
end
