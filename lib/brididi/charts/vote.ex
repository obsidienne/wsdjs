defmodule Brididi.Charts.Vote do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  alias Brididi.Repo

  @allowed_fields ~w(votes user_id song_id)a

  schema "votes" do
    field(:votes, :integer)

    belongs_to(:song, Brididi.Musics.Song, type: Brididi.HashID)
    belongs_to(:top, Brididi.Charts.Top, type: Brididi.HashID)
    belongs_to(:user, Brididi.Accounts.User, type: Brididi.HashID)

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
      Repo.get_by(Brididi.Charts.Vote, user_id: user_id, top_id: top.id, song_id: song_id) ||
        Ecto.build_assoc(top, :votes, user_id: user_id, song_id: song_id)

    Ecto.Changeset.change(struct, votes: String.to_integer(votes))
  end
end
