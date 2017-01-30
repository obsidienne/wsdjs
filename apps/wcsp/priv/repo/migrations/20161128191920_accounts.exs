defmodule Wcs.Repo.Migrations.Accounts do
  use Ecto.Migration

  def up do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string, null: false

      timestamps()
    end

    create unique_index(:accounts, [:email])
  end

  def down do
    drop table(:accounts)
  end
end
