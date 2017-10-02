defmodule Wsdjs.Repo.Migrations.AddVideoTable do
  use Ecto.Migration

  def up do
    create table(:videos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string, null: false
      add :video_id, :string

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    alter table(:user_parameters) do
      add :video, :boolean, null: false, default: false
    end
  end

  def down do
    drop table(:videos)

    alter table(:user_parameters) do
      remove :video
    end
  end
end
