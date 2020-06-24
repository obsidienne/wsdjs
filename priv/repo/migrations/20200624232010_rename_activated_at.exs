defmodule Wsdjs.Repo.Migrations.RenameActivatedAt do
  use Ecto.Migration

  def change do
    rename(table("users"), :activated_at, to: :confirmed_at)
  end
end
