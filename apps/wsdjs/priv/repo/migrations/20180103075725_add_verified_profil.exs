defmodule Wsdjs.Repo.Migrations.AddVerifiedProfil do
  use Ecto.Migration


  def up do
    alter table(:users) do
      add :verified_profil, :boolean, null: false, default: false
    end
  end

  def down do
    alter table(:users) do
      remove :verified_profil
    end
  end
end
