defmodule Wsdjs.Repo.Migrations.AddFBUrl do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :fb_url, :string
    end
  end
end
