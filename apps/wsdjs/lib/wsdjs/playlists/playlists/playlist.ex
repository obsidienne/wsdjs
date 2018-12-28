defmodule Wsdjs.Playlists.Playlist do
  @moduledoc false
  use Wsdjs.Schema
  import Ecto.{Query, Changeset}, warn: false

  @type t :: %__MODULE__{
          id: integer,
          name: String.t(),
          type: String.t(),
          public: boolean,
          count: integer,
          front_page: boolean,
          updated_at: DateTime.t(),
          inserted_at: DateTime.t()
        }

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

  def update_changeset(%__MODULE__{} = playlist, attrs) do
    playlist
    |> cast(attrs, [:public, :name, :front_page])
    |> validate_required([:public, :name])
    |> unique_constraint(:name, name: :playlists_name_user_id_index)
  end

  def changeset(%__MODULE__{} = playlist, attrs) do
    playlist
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> unique_constraint(:name, name: :playlists_name_user_id_index)
    |> assoc_constraint(:user)
  end
end
