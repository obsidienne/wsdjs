defmodule Wsdjs.Repo.Migrations.AddProvidersToSongs do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :providers, {:array, :map}, default: []
    end
  end
end
