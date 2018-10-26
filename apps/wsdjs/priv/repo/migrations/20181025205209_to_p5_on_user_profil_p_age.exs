defmodule Wsdjs.Repo.Migrations.TOP5OnUserProfilPAge do
  use Ecto.Migration

  def up do
    alter table(:playlists) do
      add(:front_page, :boolean, null: false, default: false)
    end
  end

  def down do
    alter table(:playlists) do
      remove(:front_page)
    end
  end
end
