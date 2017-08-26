defmodule Wsdjs.Repo.Migrations.AddInvitationTable do
  use Ecto.Migration

  def change do
    create table(:invitations, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :email, :string, null: false
      add :name, :string, null: false

      timestamps()
    end

    create unique_index(:invitations, [:email])
  end
end
