defmodule Wsdjs.Reactions.Opinion do
  @moduledoc false
  use Wsdjs.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer,
          kind: String.t(),
          updated_at: DateTime.t(),
          inserted_at: DateTime.t()
        }

  schema "opinions" do
    field(:kind, :string)

    belongs_to(:user, Wsdjs.Accounts.User)
    belongs_to(:song, Wsdjs.Musics.Song)

    timestamps()
  end

  @allowed_fields ~w(kind, user_id, song_id)a
  @validated_opinions ~w(up like down)
  @required_fields ~w()a

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
