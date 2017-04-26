defmodule WsdjsApi.Repo.Migrations.CreateWsdjsApi.Musics.Opinion do
  use Ecto.Migration

  def change do
    create table(:musics_opinions) do
      add :kind, :string

      timestamps()
    end

  end
end
