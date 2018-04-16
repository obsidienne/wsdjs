defmodule Wsdjs.Repo.Migrations.AddPlaceToEvent do
  use Ecto.Migration

  def up do
    alter table(:events) do
      add :venue, :string
    end
    flush()
    execute("CREATE EXTENSION IF NOT EXISTS postgis;")
    flush()
    execute("SELECT AddGeometryColumn ('events','coordinates',4326,'POINT',2);")
    create index(:events, [:coordinates], using: :gist)
  end

  def down do
    alter table(:events) do
      remove :venue
    end
  end
end
