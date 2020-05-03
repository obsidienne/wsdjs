defmodule Wsdjs.Repo.Migrations.UseIdNotUUID do
  use Ecto.Migration

  def change do
    drop table(:events)

    create table(:events) do
      add :name, :string, null: false
      add :starts_on, :date, null: false
      add :ends_on, :date, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end
  end
end
