defmodule Brididi.Repo.Migrations.RemoveUserParameters do
  use Ecto.Migration

  def change do
    drop table(:user_parameters)
  end
end
