defmodule Wsdjs.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def up do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end
  end

  def down do
    drop table(:events)
  end
end
