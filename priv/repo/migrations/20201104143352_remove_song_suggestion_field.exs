defmodule Wsdjs.Repo.Migrations.RemoveSongSuggestionField do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      remove :suggestion
    end
  end
end
