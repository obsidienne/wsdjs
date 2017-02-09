defmodule Wcsp.Repo.Migrations.AddRank do
  use Ecto.Migration

  def up do
    create table(:ranks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false
      add :top_id, references(:tops, on_delete: :nothing, type: :binary_id), null: false
      add :likes, :integer, null: false, default: 0
      add :votes, :integer, null: false, default: 0
      add :bonus, :integer, null: false, default: 0
      add :position, :integer

      timestamps()
    end
    create unique_index(:ranks, [:song_id, :top_id])
    create unique_index(:ranks, [:song_id, :top_id, :position])

  end

  def down do
    drop table(:ranks)
  end
end
