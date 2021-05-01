defmodule Brididi.Repo.Migrations.RemoveDuedateFromTops do
  use Ecto.Migration

  def change do
    alter table(:tops) do
      remove :due_date
    end
  end
end
