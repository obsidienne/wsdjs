defmodule Wsdjs.Repo.Migrations.RemovePersonnalDataForUsers do
  use Ecto.Migration

  def change do
    alter table(:user_details) do
      remove(:favorite_color)
      remove(:favorite_meal)
      remove(:favorite_animal)
      remove(:love_more)
      remove(:hate_more)
    end
  end
end
