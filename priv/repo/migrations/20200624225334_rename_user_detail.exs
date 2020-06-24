defmodule Wsdjs.Repo.Migrations.RenameUserDetail do
  use Ecto.Migration

  def change do
    rename table(:user_details), to: table(:profils)
  end
end
