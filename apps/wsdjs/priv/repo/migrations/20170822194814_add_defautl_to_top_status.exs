defmodule Wsdjs.Repo.Migrations.AddDefautlToTopStatus do
  use Ecto.Migration

  def change do
    alter table(:tops) do
      modify :status, :text, null: false, default: "checking"
    end
  end
end
