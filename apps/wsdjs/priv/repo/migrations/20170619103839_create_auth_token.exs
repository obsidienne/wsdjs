defmodule Wsdjs.Repo.Migrations.CreateWsdjs.AuthToken do
  use Ecto.Migration

  def change do
    create table(:auth_tokens) do
      add :value, :string
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)

      timestamps(updated_at: false)
    end

    create index(:auth_tokens, [:user_id])
    create unique_index(:auth_tokens, [:value])
  end
end
