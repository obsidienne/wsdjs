defmodule Wsdjs.Repo.Migrations.CreateSongOpinions do
  use Ecto.Migration

  def up do
    create table(:song_opinions, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :kind, :string, null: false

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:song_opinions, [:user_id, :song_id])
  end

  def down do
    drop table(:song_opinions)
  end
end
