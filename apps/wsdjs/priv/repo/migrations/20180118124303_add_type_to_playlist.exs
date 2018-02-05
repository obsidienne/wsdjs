defmodule Wsdjs.Repo.Migrations.AddTypeToPlaylist do
  use Ecto.Migration
  import Ecto.Query, warn: false

  def up do
    alter table(:playlists) do
      add :type, :string, null: false, default: "playlist"
    end
  end

  def down do
    alter table(:playlists) do
      remove :type
    end
  end
end
