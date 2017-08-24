defmodule Wsdjs.Repo.Migrations.ChangeUserDetails do
  use Ecto.Migration

  def change do
    alter table(:user_details) do
      add :love_more, :string
      add :hate_more, :string
      remove :tastes
    end
  end
end
