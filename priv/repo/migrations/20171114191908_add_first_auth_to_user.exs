defmodule Wsdjs.Repo.Migrations.AddFirstAuthToUser do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :activated_at, :naive_datetime
    end
  end

  def down do
    alter table(:users) do
      remove :activated_at
    end
  end
end
