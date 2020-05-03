defmodule Wsdjs.Repo.Migrations.CreateVenue do
  use Ecto.Migration

  def up do
    create table(:venues, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:venues, :name)
  end

  def down do
    drop table(:venues)
  end
end
