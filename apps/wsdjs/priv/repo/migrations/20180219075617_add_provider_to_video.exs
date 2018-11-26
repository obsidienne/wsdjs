defmodule Wsdjs.Repo.Migrations.AddProviderToVideo do
  use Ecto.Migration

  def up do
    alter table(:videos) do
      add :provider, :string, null: false, default: "unknown"
    end

    flush()

    Wsdjs.Repo.update_all("videos", set: [provider: "youtube"])
  end

  def down do
    alter table(:videos) do
      remove :provider
    end
  end
end
