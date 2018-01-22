defmodule Wsdjs.Playlists.Playlist do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Playlists.Playlist

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "playlists" do
    field :name, :string
    field :type, :string, default: "playlist"
    timestamps()

    belongs_to :user, Wsdjs.Accounts.User
    has_many :playlist_songs, Wsdjs.Playlists.PlaylistSong, on_delete: :delete_all
  end

  def changeset(%Playlist{} = playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name, name: :playlists_user_id_name_index)
    |> assoc_constraint(:user)
  end
end
