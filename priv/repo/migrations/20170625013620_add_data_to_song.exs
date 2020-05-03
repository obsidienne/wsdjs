defmodule Wsdjs.Repo.Migrations.AddDataToSong do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :instant_hit, :boolean, null: false, default: false
      add :hidden, :boolean, null: false, default: false
    end
  end
end
