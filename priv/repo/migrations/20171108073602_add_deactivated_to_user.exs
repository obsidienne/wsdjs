defmodule Wsdjs.Repo.Migrations.AddDeactivatedToUser do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :deactivated, :boolean, null: false, default: false
    end
  end

  def down do
    alter table(:users) do
      remove :deactivated
    end
  end
end
