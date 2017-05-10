defmodule Wcsp.Repo.Migrations.RecreateIndex do
  use Ecto.Migration

  def change do
    drop index(:users, [:email])
    drop index(:songs, [:title, :artist])
    drop index(:tops, [:due_date])
    drop index(:ranks, [:song_id, :top_id])
    drop index(:ranks, [:song_id, :top_id, :position])
    drop index(:album_arts, [:cld_id])
    drop index(:avatars, [:cld_id])
    drop index(:song_opinions, [:user_id, :song_id])
    drop index(:rank_songs, [:song_id, :top_id, :user_id])

    create unique_index(:accounts_users, [:email])
    create unique_index(:musics_songs, [:title, :artist])
    create unique_index(:trendings_tops, [:due_date])
    create unique_index(:trendings_ranks, [:song_id, :top_id])
    create unique_index(:trendings_ranks, [:song_id, :top_id, :position])
    create unique_index(:musics_arts, [:cld_id])
    create unique_index(:accounts_avatars, [:cld_id])
    create unique_index(:musics_opinions, [:user_id, :song_id])
    create unique_index(:trendings_votes, [:song_id, :top_id, :user_id])
  end
end
