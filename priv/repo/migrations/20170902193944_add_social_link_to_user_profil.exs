defmodule Wsdjs.Repo.Migrations.AddSocialLinkToUserProfil do
  use Ecto.Migration

  def change do
    alter table(:user_details) do
      add :youtube, :string
      add :facebook, :string
      add :soundcloud, :string
    end
  end
end
