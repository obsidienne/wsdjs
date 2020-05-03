defmodule Wsdjs.Repo.Migrations.RemoveTopVisibility do
  use Ecto.Migration

  def change do
    alter table(:playlists) do
      remove :visibility
    end
  end
end
