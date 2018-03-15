defmodule Wsdjs.Repo.Migrations.AddEventToVideo do
  use Ecto.Migration

  def up do
    alter table(:videos) do
      add :event_id, references(:events, on_delete: :nothing), null: true
    end
  end

  def down do
    alter table(:videos) do
      remove :event_id
    end
  end
end
