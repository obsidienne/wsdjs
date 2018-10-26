defmodule Wsdjs.Repo.Migrations.RemovePublicTopLikeFromUserParams do
  use Ecto.Migration

  def change do
    alter table(:user_parameters) do
      remove(:public_top_like)
    end
  end
end
