defmodule Wsdjs.Repo.Migrations.AddDateToVideo do
  use Ecto.Migration

  def up do
    alter table(:videos) do
      add :published_at, :date
    end
  end

  def down do
    alter table(:videos) do
      remove :published_at
    end
  end
end
