defmodule Wcs.Repo.Migrations.RenameUsersToAccounts do
  use Ecto.Migration

  def up do
    rename table(:users), to: table(:accounts)
  end

  def down do
    rename table(:accounts), to: table(:users)
  end
end
