defmodule Wsdjs.Repo.Migrations.AddPiwikFeatureToggle do
  use Ecto.Migration

  def change do
    alter table(:user_parameters) do
      add :piwik, :boolean, null: false, default: true
    end
  end
end
