defmodule Wsdjs.Repo.Migrations.RemoveVenue do
  use Ecto.Migration

  def change do
    drop table(:venues)
  end
end
