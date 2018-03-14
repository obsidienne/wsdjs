defmodule Wsdjs.Repo.Migrations.AddDateToHappening do
  use Ecto.Migration

  def up do
    alter table(:events) do
      add :starts_on, :date, null: false
      add :ends_on, :date, null: false
    end
  end

  def down do
    alter table(:events) do
      remove :starts_on
      remove :ends_on
    end
  end
end
