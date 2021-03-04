defmodule Brididi.Repo.Migrations.MoveArtToSong do
  use Ecto.Migration

  def change do
    alter table(:songs) do
      add :cld_id, :string, null: false, default: "brididi/missing_cover"
    end

    execute "
    update songs
    set cld_id=arts.cld_id
    from arts
    where arts.song_id=songs.id"
  end
end
