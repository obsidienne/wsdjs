defmodule Wcs.Repo.Migrations.Citext do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS citext"
  end

  def down do
    execute "DROP EXTENSION citext"
  end
end
