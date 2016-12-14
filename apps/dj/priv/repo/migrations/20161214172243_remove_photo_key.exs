defmodule Dj.Repo.Migrations.RemovePhotoKey do
  use Ecto.Migration

  def up do
    alter table(:songs) do
      remove :photo_id
    end
  end

  def down do
    alter table(:songs) do
      add :photo_id, references(:photos, on_delete: :nothing, type: :binary_id), null: false
    end
  end
end
