defmodule Wcs.Repo.Migrations.RenameUserColumnToAccountColumn do
  use Ecto.Migration

  def up do
    rename table(:photos), :user_id, to: :account_id
    rename table(:songs), :user_id, to: :account_id
    rename table(:tops), :user_id, to: :account_id
  end

  def down do
    rename table(:photos), :account_id, to: :user_id
    rename table(:songs), :account_id, to: :user_id
    rename table(:tops), :account_id, to: :user_id
  end
end
