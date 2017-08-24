defmodule Wsdjs.Repo.Migrations.RemoveUserForeignKey do
  use Ecto.Migration

  def change do
    alter table(:arts) do
      remove :user_id
    end
  end
end
