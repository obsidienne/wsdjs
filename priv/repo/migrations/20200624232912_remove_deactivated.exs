defmodule Wsdjs.Repo.Migrations.RemoveDeactivated do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove(:deactivated)
      remove :verified_profil
    end
  end
end
