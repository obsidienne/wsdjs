defmodule User.Repo.Migrations.AddMissingUserFields do
  use Ecto.Migration

  def up do
    alter table(:users) do
      add :admin, :boolean, null: false, default: false
      add :new_song_notification, :boolean, null: false, default: false
      add :user_country, :string
      add :last_name, :string
      add :first_name, :string
      add :djname, :string
    end
  end

  def down do
    alter table(:users) do
      remove :admin
      remove :new_song_notification
      remove :user_country
      remove :last_name
      remove :first_name
      remove :djname
    end
  end
end
