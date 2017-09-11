defmodule Wsdjs.Repo.Migrations.AddBoolForProfils do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profil_djvip, :boolean, null: false, default: false
      add :profil_dj, :boolean, null: false, default: false
    end
  end
end
