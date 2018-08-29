defmodule Wsdjs.Playlists.PlaylistSong do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias Wsdjs.Playlists.PlaylistSong
  alias Wsdjs.Repo

  schema "playlist_songs" do
    field(:position, :integer)
    timestamps(updated_at: false)

    belongs_to(:playlist, Wsdjs.Playlists.Playlist, type: Wsdjs.HashID)
    belongs_to(:song, Wsdjs.Musics.Song, type: :binary_id)
  end

  def changeset(%PlaylistSong{} = playlist_songs, attrs) do
    playlist_songs
    |> cast(attrs, [:playlist_id, :song_id, :position])
    |> validate_required([:playlist_id, :song_id, :position])
    |> validate_number(:position, greater_than_or_equal_to: 0)
    |> assoc_constraint(:song)
  end

  def get_or_build(playlist, song_id, position) do
    struct =
      Repo.get_by(Wsdjs.Playlists.PlaylistSong, playlist_id: playlist.id, song_id: song_id) ||
        Ecto.build_assoc(playlist, :playlist_songs, song_id: song_id)

    Changeset.change(struct, position: String.to_integer(position))
  end
end
