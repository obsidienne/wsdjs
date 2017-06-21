defmodule Wsdjs.Repo.Migrations.CreateRankSong do
  use Ecto.Migration

  def up do
    create table(:rank_songs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false
      add :top_id, references(:tops, on_delete: :nothing, type: :binary_id), null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false

      add :votes, :integer, null: false, default: 0

      timestamps()
    end
    create unique_index(:rank_songs, [:song_id, :top_id, :user_id])

  end

  def down do
    drop table(:rank_songs)
  end
end
