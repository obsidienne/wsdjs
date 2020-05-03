defmodule Wsdjs.Repo.Migrations.AddRadioKingPref do
  use Ecto.Migration

  def up do
    alter table(:user_parameters) do
      add :radioking_unmatch, :boolean, null: false, default: false
    end
  end

  def down do
    alter table(:user_parameters) do
      remove :radioking_unmatch
    end
  end
end
