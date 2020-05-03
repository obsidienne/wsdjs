defmodule Wsdjs.Repo.Migrations.CreateList do
  use Ecto.Migration

  def change do
    create table(:playlists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:playlists, [:user_id, :name])
  end
end
