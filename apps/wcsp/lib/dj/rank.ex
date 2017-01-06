defmodule Wcsp.Rank do
  use Wcsp.Model

  schema "ranks" do
    field :likes, :integer
    field :votes, :integer
    field :bonus, :integer

    belongs_to :song, Wcsp.Song
    belongs_to :top, Wcsp.Top

    timestamps()
  end

  @allowed_fields [:likes, :votes, :bonus, :song_id, :top_id]

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> assoc_constraint(:song)
    |> assoc_constraint(:top)
    |> validate_number(:votes, greater_than: 0)
    |> validate_number(:bonus, greater_than: 0)
  end
end
