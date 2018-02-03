defmodule Wsdjs.Repo.Migrations.OptionForEmail do
  use Ecto.Migration

  def up do
    alter table(:user_parameters) do
      add :email_contact, :boolean, null: false, default: false
    end
  end

  def down do
    alter table(:user_parameters) do
      remove :email_contact
    end
  end
end
