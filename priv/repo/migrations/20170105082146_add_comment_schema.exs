defmodule Wsdjs.Repo.Migrations.AddCommentSchema do
  use Ecto.Migration

  def up do
    create table(:comments, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), null: false
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id), null: false
      add :text, :string, null: false

      timestamps()
    end
  end

  def down do
    drop table(:comments)
  end
end
