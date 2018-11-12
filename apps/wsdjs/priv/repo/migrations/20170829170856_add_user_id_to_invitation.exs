defmodule Wsdjs.Repo.Migrations.AddUserIdToInvitation do
  use Ecto.Migration

  def up do
    alter table(:invitations) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: true
    end

    create unique_index(:invitations, [:user_id])
  end

  def down do
    alter table(:invitations) do
      remove :user_id
    end
  end
end
