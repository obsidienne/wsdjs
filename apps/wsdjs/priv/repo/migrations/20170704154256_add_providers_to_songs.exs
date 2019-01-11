defmodule Wsdjs.Repo.Migrations.AddAttachmentsToSongs do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :video_id, :string
    end
  end
end
