defmodule Wsdjs.Repo.Migrations.AddUserProfils do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :profils, {:array, :string}, default: []
    end
  end
end
