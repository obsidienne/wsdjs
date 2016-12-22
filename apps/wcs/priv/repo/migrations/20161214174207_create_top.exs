defmodule Dj.Repo.Migrations.CreateTop do
  use Ecto.Migration

  def up do
    create table(:tops, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :due_date, :date, null: false
      add :status, :string, null: false

      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id), null: false

      timestamps
    end

    create unique_index(:tops, :due_date)
  end

  def down do
    drop table(:tops)
  end
end
