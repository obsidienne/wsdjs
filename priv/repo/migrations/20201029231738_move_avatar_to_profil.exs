defmodule Wsdjs.Repo.Migrations.MoveAvatarToProfil do
  use Ecto.Migration
  import Ecto.Query

  def change do
    rename table(:profils), to: table(:users_profils)
    flush()

    alter table(:users_profils) do
      add :cld_id, :string, null: false, default: "wsdjs/missing_avatar"
    end

    execute "
    update users_profils
    set cld_id=avatars.cld_id
    from avatars
    where avatars.user_id=users_profils.user_id"
  end
end
