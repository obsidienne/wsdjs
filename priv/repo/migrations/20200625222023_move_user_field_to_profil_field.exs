defmodule Wsdjs.Repo.Migrations.MoveUserFieldToProfilField do
  use Ecto.Migration

  def up do
    alter table(:profils) do
      add :user_country, :string
      add :name, :string
      add :djname, :string
    end

    flush()

    execute "
    insert into profils(user_country, name, djname, user_id, inserted_at, updated_at)
    select user_country
          , name
          , djname
          , id
          , now() at time zone 'utc'
          , now() at time zone 'utc'
    from users
    where id not in (select user_id from profils)
    "

    execute "
    update  profils
    set user_country=users.user_country
      , name=users.name
      , djname=users.djname
    from users
    where users.id in (select user_id from profils)
    "

    alter table(:users) do
      remove :user_country
      remove :name
      remove :djname
    end
  end

  def down do
    alter table(:users) do
      add :user_country, :string
      add :name, :string
      add :djname, :string
    end

    alter table(:profils) do
      remove :user_country
      remove :name
      remove :djname
    end
  end
end
