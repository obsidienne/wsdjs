defmodule Wsdjs.Repo.Migrations.RenameRankUserToVote do
  use Ecto.Migration

  def change do
    rename table(:rank_songs), to: table(:votes)
  end
end
