defmodule Wcsp.Repo.Migrations.AddFullTextSearch do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS unaccent;"
    execute "CREATE EXTENSION IF NOT EXISTS pg_trgm;"
  end
end
