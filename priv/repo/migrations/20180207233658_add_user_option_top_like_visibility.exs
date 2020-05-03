defmodule Wsdjs.Repo.Migrations.AddUserOptionTopLikeVisibility do
  use Ecto.Migration

  def up do
    alter table(:user_parameters) do
      add :public_top_like, :boolean, null: false, default: false
    end
  end

  def down do
    alter table(:user_parameters) do
      remove :public_top_like
    end
  end
end
