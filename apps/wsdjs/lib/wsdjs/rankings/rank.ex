defmodule Wsdjs.Rankings.Rank do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ranks" do
    field :likes, :integer
    field :votes, :integer
    field :bonus, :integer
    field :position, :integer

    belongs_to :song, Wsdjs.Musics.Song
    belongs_to :top, Wsdjs.Rankings.Top

    timestamps()
  end

  @allowed_fields [:likes, :votes, :bonus, :song_id, :top_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> assoc_constraint(:song)
    |> assoc_constraint(:top)
    |> unique_constraint(:song_id, name: :ranks_song_id_top_id_index)
    |> validate_number(:votes, greater_than: 0)
    |> validate_number(:bonus, greater_than: 0)
    |> validate_number(:position, greater_than: 0)
  end
end
