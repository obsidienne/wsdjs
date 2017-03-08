defmodule Wcsp.RankSong do
  @moduledoc """
  This is the RankSong module. It aims to store a DJ vote:
  The votes is the position of the song between 1 and count(ranks) for top)

  position: filled and freezed in publish
  """
  use Wcsp.Schema

  schema "rank_songs" do
    field :votes, :integer

    belongs_to :song, Wcsp.Song
    belongs_to :top, Wcsp.Top
    belongs_to :user, Wcsp.User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:votes])
    |> assoc_constraint(:song)
    |> assoc_constraint(:user)
    |> assoc_constraint(:top)
    |> validate_number(:votes, greater_than: 0)
    |> validate_number(:votes, less_than_or_equal_to: 10)
  end

  def for_user_and_top(top, user) do
    from r in Wcsp.RankSong,
    where: r.user_id == ^user.id and r.top_id == ^top.id
  end
end
