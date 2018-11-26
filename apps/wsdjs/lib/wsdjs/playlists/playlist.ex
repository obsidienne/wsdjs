defmodule Wsdjs.Playlists.Playlist do
  @moduledoc false
  use Ecto.Schema
  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Accounts.User
  alias Wsdjs.Playlists.Playlist

  @primary_key {:id, Wsdjs.HashID, autogenerate: true}
  @foreign_key_type Wsdjs.HashID
  schema "playlists" do
    field(:name, :string)
    field(:type, :string, default: "playlist")
    field(:public, :boolean, default: false)
    field(:count, :integer, default: 0)
    field(:front_page, :boolean, default: false)
    timestamps()

    belongs_to(:user, Wsdjs.Accounts.User)
    belongs_to(:cover, Wsdjs.Musics.Song)
    has_many(:playlist_songs, Wsdjs.Playlists.PlaylistSong, on_delete: :delete_all)
  end

  def types, do: ["suggested", "likes and tops", "playlist", "top 5"]

  def update_changeset(%Playlist{} = playlist, attrs) do
    playlist
    |> cast(attrs, [:public, :name, :front_page])
    |> validate_required([:public, :name])
  end

  def changeset(%Playlist{} = playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name, name: :playlists_user_id_name_index)
    |> assoc_constraint(:user)
  end

  def scoped(%User{admin: true}), do: Playlist

  def scoped(%User{id: id}) do
    from(p in Playlist, where: p.user_id == ^id or p.public == true)
  end

  def scoped(_), do: from(p in Playlist, where: p.public == true)
end
