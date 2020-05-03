defmodule Wsdjs.Repo.Migrations.AddTitleAndPlaceToVideo do
  use Ecto.Migration

  def up do
    alter table(:videos) do
      add :title, :string
      add :event, :string
    end
  end

  def down do
    alter table(:videos) do
      remove :title
      remove :place
    end
  end
end
