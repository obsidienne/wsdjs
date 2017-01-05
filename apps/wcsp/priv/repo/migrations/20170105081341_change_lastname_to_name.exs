defmodule Wcsp.Repo.Migrations.ChangeLastnameToName do
  use Ecto.Migration

  def up do
    alter table(:accounts) do
      add :name, :string
      remove :last_name
      remove :first_name
    end
  end

  def down do
    alter table(:accounts) do
      add :last_name, :string
      add :first_name, :string
      remove :name
    end
  end
end
