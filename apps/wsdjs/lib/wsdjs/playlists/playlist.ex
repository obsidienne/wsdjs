defmodule Wsdjs.Playlists.Playlist do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Playlists.Playlist

  schema "playlists" do
    field(:name, :string)
    field(:type, :string, default: "playlist")
    field(:visibility, :string, default: "private")
    field(:count, :integer, default: 0)
    timestamps()

    belongs_to(:user, Wsdjs.Accounts.User, type: :binary_id)
    belongs_to(:song, Wsdjs.Musics.Song, type: :binary_id)
    has_many(:playlist_songs, Wsdjs.Playlists.PlaylistSong, on_delete: :delete_all)
  end

  def update_changeset(%Playlist{} = playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :visibility])
    |> validate_required([:name, :visibility])
    |> unique_constraint(:name, name: :playlists_user_id_name_index)
  end

  def changeset(%Playlist{} = playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :user_id, :visibility])
    |> validate_required([:name, :user_id, :visibility])
    |> unique_constraint(:name, name: :playlists_user_id_name_index)
    |> assoc_constraint(:user)
  end
end
