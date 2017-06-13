defmodule Wcsp.Repo.Migrations.RenameTables do
  use Ecto.Migration

  def change do
    rename table(:album_arts), to: table(:arts)
    rename table(:song_opinions), to: table(:opinions)
  end
end
