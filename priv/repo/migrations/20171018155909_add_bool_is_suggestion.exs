defmodule Wsdjs.Repo.Migrations.AddBoolIsSuggestion do
  use Ecto.Migration

  def up do
    alter table(:songs) do
      add :suggestion, :boolean, null: false, default: true
    end
  end

  def down do
    alter table(:invitations) do
      remove :suggestion
    end
  end
end
