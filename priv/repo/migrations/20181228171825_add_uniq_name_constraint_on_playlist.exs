defmodule Wsdjs.Repo.Migrations.AddUniqNameConstraintOnPlaylist do
  use Ecto.Migration

  def change do
    create unique_index(:playlists, [:name, :user_id])
  end
end
