defmodule Wsdjs.Repo.Migrations.AddPublicTrackToSong do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :public_track, :boolean, null: false, default: false
      add :hidden_track, :boolean, null: false, default: false
      remove :hidden
    end
  end
end
