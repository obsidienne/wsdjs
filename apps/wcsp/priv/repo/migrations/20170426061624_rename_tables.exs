defmodule Wcsp.Repo.Migrations.RenameTables do
  use Ecto.Migration

  def change do
    rename table(:album_arts), to: table(:musics_arts)
    rename table(:comments), to: table(:musics_comments)
    rename table(:song_opinions), to: table(:musics_opinions)
    rename table(:songs), to: table(:musics_songs)

    rename table(:ranks), to: table(:trendings_ranks)
    rename table(:tops), to: table(:trendings_tops)
    rename table(:votes), to: table(:trendings_votes)

    rename table(:users), to: table(:accounts_users)
    rename table(:avatars), to: table(:accounts_avatars)
  end
end
