defmodule Wcsp.Trendings.Vote do
  @moduledoc """
  This is the Vote module. It aims to store a DJ vote:
  The votes is the position of the song between 1 and count(ranks) for top)

  position: filled and freezed in publish
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Wcsp.{Musics, Trendings, Accounts}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "votes" do
    field :votes, :integer

    belongs_to :song, Musics.Song
    belongs_to :top, Trendings.Top
    belongs_to :user, Accounts.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:votes, :user_id, :song_id])
    |> assoc_constraint(:song)
    |> assoc_constraint(:user)
    |> assoc_constraint(:top)
    |> validate_number(:votes, greater_than: 0)
    |> validate_number(:votes, less_than_or_equal_to: 10)
  end

  def get_or_build(top, user_id, song_id, votes) do
    struct =
      Wcsp.Repo.get_by(Trendings.Vote, user_id: user_id, top_id: top.id, song_id: song_id) ||
      Ecto.build_assoc(top, :votes, user_id: user_id, song_id: song_id)

    Ecto.Changeset.change(struct, votes: String.to_integer(votes))
  end
end
