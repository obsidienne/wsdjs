defmodule Wsdjs.Charts.Rank do
  @moduledoc """
  A rank in a chart.
  """
  use Wsdjs.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer,
          likes: integer,
          votes: integer,
          bonus: integer,
          position: integer,
          updated_at: DateTime.t(),
          inserted_at: DateTime.t()
        }

  @allowed_fields ~w(likes, votes, bonus, song_id, top_id)a

  schema "ranks" do
    field(:likes, :integer)
    field(:votes, :integer)
    field(:bonus, :integer)
    field(:position, :integer)

    belongs_to(:song, Wsdjs.Musics.Song)
    belongs_to(:top, Wsdjs.Charts.Top)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = rank, attrs) do
    rank
    |> cast(attrs, @allowed_fields)
    |> assoc_constraint(:song)
    |> assoc_constraint(:top)
    |> unique_constraint(:song_id, name: :ranks_song_id_top_id_index)
    |> validate_number(:votes, greater_than_or_equal_to: 0)
    |> validate_number(:bonus, greater_than_or_equal_to: 0)
  end
end
