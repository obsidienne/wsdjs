defmodule Wsdjs.Repo.Migrations.AddOptionForTopVisibility do
  use Ecto.Migration

  def up do
    alter table(:playlists) do
      add :visibility, :string, null: false, default: "private"
    end
  end

  def down do
    alter table(:user_parameters) do
      remove :visibility
    end
  end
end
