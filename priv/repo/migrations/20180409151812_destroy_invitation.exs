defmodule Wsdjs.Repo.Migrations.DestroyInvitation do
  use Ecto.Migration

  def change do
    drop table(:invitations)
  end
end
