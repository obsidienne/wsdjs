defmodule Brididi.Charts.Rank do
  @moduledoc """
  A rank in a chart.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @allowed_fields ~w(likes votes song_id top_id)a

  schema "ranks" do
    field(:likes, :integer)
    field(:votes, :integer)
    field(:bonus, :integer)
    field(:position, :integer)

    belongs_to(:song, Brididi.Musics.Song, type: Brididi.HashID)
    belongs_to(:top, Brididi.Charts.Top, type: Brididi.HashID)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = rank, attrs) do
    rank
    |> cast(attrs, @allowed_fields)
    |> assoc_constraint(:song)
    |> assoc_constraint(:top)
    |> validate_number(:votes, greater_than_or_equal_to: 0)
  end
end
