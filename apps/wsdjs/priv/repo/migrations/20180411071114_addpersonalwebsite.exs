defmodule Wsdjs.Repo.Migrations.Addpersonalwebsite do
  use Ecto.Migration

  def change do
    alter table(:user_details) do
      add :website, :string
    end
  end
end
