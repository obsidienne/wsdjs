defmodule Wsdjs.Repo.Migrations.UpdateTOP5 do
  use Ecto.Migration

  import Ecto.{Query, Changeset}, warn: false

  alias Wsdjs.Playlists.Playlist
  alias Wsdjs.Playlists.PlaylistSong
  alias Wsdjs.Repo

  def change do
    query = from(ps in Playlist, select: %{id: ps.id})

    query
    |> Repo.all()
    |> Enum.each(fn playlist -> sort(playlist.id) end)
  end

  defp sort(playlist_id) do
    query =
      from(
        ps in PlaylistSong,
        join:
          r in fragment("""
          SELECT id, playlist_id, row_number() OVER (
            PARTITION BY playlist_id
            ORDER BY position
          ) as rn FROM playlist_songs
          """),
        where: ps.playlist_id == ^playlist_id and ps.id == r.id,
        select: %{id: ps.id, pos: r.rn}
      )

    query
    |> Repo.all()
    |> Enum.each(fn rank ->
      # credo:disable-for-lines:2
      from(ps in PlaylistSong, where: [id: ^rank.id])
      |> Repo.update_all(set: [position: rank.pos])
    end)
  end
end
