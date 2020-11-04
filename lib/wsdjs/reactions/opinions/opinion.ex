defmodule Wsdjs.Reactions.Opinions.Opinion do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_fields ~w(kind user_id song_id)a
  @validated_opinions ~w(up like down)
  @required_fields ~w(kind)a

  schema "opinions" do
    field(:kind, :string)

    belongs_to(:user, Wsdjs.Accounts.User, type: Wsdjs.HashID)
    belongs_to(:song, Wsdjs.Songs.Song, type: Wsdjs.HashID)

    timestamps()
  end

  def changeset(%__MODULE__{} = opinion, attrs) do
    opinion
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:kind, @validated_opinions)
    |> unique_constraint(:song_id, name: :song_opinions_user_id_song_id_index)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
  end
end
