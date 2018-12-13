defmodule Wsdjs.Charts.Vote do
  @moduledoc false
  use Wsdjs.Schema
  import Ecto.Changeset

  alias Wsdjs.{Accounts, Charts, Musics, Repo}

  @type t :: %__MODULE__{
          id: integer,
          votes: integer,
          updated_at: DateTime.t(),
          inserted_at: DateTime.t()
        }

  @allowed_fields ~w(votes user_id song_id)a

  schema "votes" do
    field(:votes, :integer)

    belongs_to(:song, Musics.Song)
    belongs_to(:top, Charts.Top)
    belongs_to(:user, Accounts.User)

    timestamps()
  end

  def changeset(%__MODULE__{} = vote, attrs) do
    vote
    |> cast(attrs, @allowed_fields)
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

    Ecto.Changeset.change(struct, votes: String.to_integer(votes))
  end
end
