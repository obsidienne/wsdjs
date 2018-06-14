defmodule Wsdjs.Repo.Migrations.AddUserParamsTable do
  use Ecto.Migration

  def change do
    create table(:user_parameters) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      add :new_song_notification, :boolean, null: false, default: false
      add :userback, :boolean, null: false, default: false

      timestamps()
    end

    alter table(:users) do
      remove :new_song_notification
    end

    create unique_index(:user_parameters, [:user_id])
  end
end
