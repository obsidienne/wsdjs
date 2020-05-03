defmodule Wsdjs.Repo.Migrations.RemoveUserbackFeatureToggle do
  use Ecto.Migration

  def change do
    alter table(:user_parameters) do
      remove :userback
    end
  end
end
