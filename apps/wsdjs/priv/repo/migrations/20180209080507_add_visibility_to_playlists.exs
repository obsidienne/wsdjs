defmodule Wsdjs.Repo.Migrations.AddVisibilityToPlaylists do
  use Ecto.Migration

  import Ecto.Query, warn: false

  def up do
    alter table(:playlists) do
      add :public, :boolean, null: false, default: false
    end

    flush()

    from(p in "playlists", where: p.type == "suggested")
    |> Wsdjs.Repo.update_all(set: [public: true])
  end

  def down do
    alter table(:playlists) do
      remove :public
    end
  end
end
