defmodule Wcsp.Repo.Migrations.AddAvatarToAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :avatar_id, references(:avatars, on_delete: :nothing, type: :binary_id)
    end
  end
end
