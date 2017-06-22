defmodule Wsdjs.Trendings.Rank do
  @moduledoc """
  This is the Rank module. It aims to store for a Wsdjs.Top :
    - the songs
    - the total likes/votes/bonus
    - the position
  It does not store the DJ votes !

  likes: filled at the creation according
  votes: filled and freezed when the voting for a Top is closed
  bonus: filled only if the top is in the counting status and freezed on publish
  position: filled and freezed in publish
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ranks" do
    field :likes, :integer
    field :votes, :integer
    field :bonus, :integer
    field :position, :integer

    belongs_to :song, Wsdjs.Musics.Song
    belongs_to :top, Wsdjs.Trendings.Top

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

  def bonus_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:bonus])
    |> validate_number(:bonus, greater_than: 0)
  end

  def position_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:position])
    |> validate_number(:position, greater_than: 0)
  end

  def for_top(id) do
    from q in __MODULE__,
    where: q.top_id == ^id,
    order_by: [desc: fragment("? + ? + ?", q.votes, q.bonus, q.likes)],
    preload: [song: [{:art, :user}, :opinions]]
  end

  def for_tops_with_limit(per \\ 10) do
    from q in __MODULE__,
      join: p in fragment("""
      SELECT id, top_id, row_number() OVER (
        PARTITION BY top_id
        ORDER BY votes + bonus + likes DESC
      ) as rn FROM ranks
      """),
    where: p.rn <= ^per and p.id == q.id,
    order_by: [asc: q.position],
    preload: [song: :art]
  end
end
