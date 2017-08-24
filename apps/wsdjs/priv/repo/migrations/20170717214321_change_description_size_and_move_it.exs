defmodule Wsdjs.Repo.Migrations.ChangeDescriptionSizeAndMoveIt do
  use Ecto.Migration

  def change do
    create table(:user_details) do
      add :description, :text
      add :favorite_genre, :string
      add :favorite_artist, :string
      add :favorite_color, :string
      add :favorite_meal, :string
      add :favorite_animal, :string
      add :djing_start_year, :int
      add :tastes, :text

      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    alter table(:users) do
      remove :description
    end
  end
end
