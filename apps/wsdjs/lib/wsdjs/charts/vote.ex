defmodule Wsdjs.Charts.Vote do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.Changeset

  alias Wsdjs.Accounts
  alias Wsdjs.Charts
  alias Wsdjs.Musics
  alias Wsdjs.Repo

  @primary_key {:id, Wsdjs.HashID, autogenerate: true}
  @foreign_key_type Wsdjs.HashID
  schema "votes" do
    field(:votes, :integer)

    belongs_to(:song, Musics.Song)
    belongs_to(:top, Charts.Top)
    belongs_to(:user, Accounts.User)

    timestamps()
  end

  def changeset(%__MODULE__{} = vote, attrs) do
    vote
    |> cast(attrs, [:votes, :user_id, :song_id])
    |> assoc_constraint(:song)
    |> assoc_constraint(:user)
    |> assoc_constraint(:top)
    |> validate_number(:votes, greater_than: 0)
    |> validate_number(:votes, less_than_or_equal_to: 10)
  end

  def get_or_build(top, user_id, song_id, votes) do
    struct =
      Repo.get_by(Charts.Vote, user_id: user_id, top_id: top.id, song_id: song_id) ||
        Ecto.build_assoc(top, :votes, user_id: user_id, song_id: song_id)

    Changeset.change(struct, votes: String.to_integer(votes))
  end
end
