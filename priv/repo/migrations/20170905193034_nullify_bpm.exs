defmodule Wsdjs.Repo.Migrations.NullifyBPM do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      modify :bpm, :integer, null: true
    end
  end
end
