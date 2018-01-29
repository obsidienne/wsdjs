defmodule Wsdjs.Repo.Migrations.AddSongAndCountToPlaylist do
  use Ecto.Migration
  import Ecto.Query, warn: false

  def up do
    alter table(:playlists) do
      add :song_id, references(:songs, on_delete: :nothing, type: :binary_id)
      add :count, :int, default: 0, null: false
    end

    suggested_playlists = Wsdjs.Repo.all(from s in Wsdjs.Musics.Song, distinct: s.user_id, select: %{user_id: Ecto.UUID.dump(s.user_id), type: "suggested"})

    Wsdjs.Repo.insert_all "playlists", suggested_playlists
  end

  def down do
    alter table(:playlists) do
      remove :song_id
      remove :count
    end
  end
end
