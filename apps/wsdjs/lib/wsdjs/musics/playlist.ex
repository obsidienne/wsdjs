defmodule Wsdjs.Musics.Playlist do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Musics.Playlist

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "playlists" do
    field :name, :string
    timestamps()

    belongs_to :user, Accounts.User
  end

  @allowed_fields [:name, :user_id]
  @required_fields [:name, :user_id]

  def changeset(%Playlist{} = playlist, attrs) do
    playlist
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name, name: :playlists_user_id_name_index)
    |> assoc_constraint(:user)
  end
end
