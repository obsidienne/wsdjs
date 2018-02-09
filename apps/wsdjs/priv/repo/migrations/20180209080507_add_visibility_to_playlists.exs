defmodule Wsdjs.Repo.Migrations.AddVisibilityToPlaylists do
  use Ecto.Migration

  import Ecto.Query, warn: false

  def up do
    alter table(:playlists) do
      add :visibility, :string, null: false, default: "private"
    end

    flush()

    from(p in "playlists", where: p.type == "suggested")
    |> Wsdjs.Repo.update_all(set: [visibility: "public"])
  end

  def down do
    alter table(:playlists) do
      remove :visibility
    end
  end

end
