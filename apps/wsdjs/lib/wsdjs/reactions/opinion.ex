defmodule Wsdjs.Reactions.Opinion do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Reactions.Opinion

  @primary_key {:id, Wsdjs.HashID, autogenerate: true}
  @foreign_key_type Wsdjs.HashID
  schema "opinions" do
    field(:kind, :string)

    belongs_to(:user, Wsdjs.Accounts.User)
    belongs_to(:song, Wsdjs.Musics.Song)

    timestamps()
  end

  @allowed_fields [:kind, :user_id, :song_id]
  @validated_opinions ~w(up like down)

  def changeset(%Opinion{} = opinion, attrs) do
    opinion
    |> cast(attrs, @allowed_fields)
    |> validate_required([:kind])
    |> validate_inclusion(:kind, @validated_opinions)
    |> unique_constraint(:song_id, name: :song_opinions_user_id_song_id_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
  end
end
