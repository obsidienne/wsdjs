defmodule Wsdjs.Repo.Migrations.AddVideoTable do
  use Ecto.Migration

  def up do
    create table(:videos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end
  end

  def down do
    drop table(:videos)
  end
end
