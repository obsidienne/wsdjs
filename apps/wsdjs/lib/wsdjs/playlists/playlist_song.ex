defmodule Wsdjs.Playlists.PlaylistSong do
  @moduledoc false
  use Ecto.Schema

  import Ecto.{Query, Changeset}, warn: false

  alias Ecto.Changeset
  alias Wsdjs.Accounts.User
  alias Wsdjs.Playlists.PlaylistSong
  alias Wsdjs.Repo

  @primary_key {:id, Wsdjs.HashID, autogenerate: true}
  @foreign_key_type Wsdjs.HashID
  schema "playlist_songs" do
    field(:position, :integer)
    timestamps(updated_at: false)

    belongs_to(:playlist, Wsdjs.Playlists.Playlist)
    belongs_to(:song, Wsdjs.Musics.Song)
  end

  def changeset(%__MODULE__{} = playlist_songs, attrs) do
    playlist_songs
    |> cast(attrs, [:playlist_id, :song_id, :position])
    |> validate_required([:playlist_id, :song_id, :position])
    |> validate_number(:position, greater_than_or_equal_to: 0)
    |> unique_constraint(:song_id, name: :playlist_songs_playlist_id_song_id_index)
    |> assoc_constraint(:song)
  end

  def scoped(%User{admin: true}), do: PlaylistSong

  def scoped(%User{id: id}) do
    from(
      ps in PlaylistSong,
      join: p in assoc(ps, :playlist),
      where: p.user_id == ^id
    )
  end

  def scoped(_) do
    from(
      ps in PlaylistSong,
      join: p in assoc(ps, :playlist),
      where: (ps.position <= 5 and p.type == "top 5") or p.type != "top 5"
    )
  end

  def get_or_build(playlist, song_id, position) do
    struct =
      Repo.get_by(Wsdjs.Playlists.PlaylistSong, playlist_id: playlist.id, song_id: song_id) ||
        Ecto.build_assoc(playlist, :playlist_songs, song_id: song_id)

    Changeset.change(struct, position: String.to_integer(position))
  end
end
