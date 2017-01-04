defmodule Photo.Repo.Migrations.Photo do
  use Ecto.Migration

  def up do
    create table(:photos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :cld_id, :string, null: false
      add :version, :timestamp, null: false
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id), null: false

      timestamps
    end

    create unique_index(:photos, [:cld_id])
  end

  def down do
    drop table(:photos)
  end

end
