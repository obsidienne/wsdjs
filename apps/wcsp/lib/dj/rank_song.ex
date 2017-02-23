defmodule Wcsp.RankSong do
  @moduledoc """
  This is the RankSong module. It aims to store a DJ vote:
  The votes is the position of the song between 1 and count(ranks) for top)

  position: filled and freezed in publish
  """
  use Wcsp.Model

  schema "rank_songs" do
    field :votes, :integer

    belongs_to :song, Wcsp.Song
    belongs_to :top, Wcsp.Top
    belongs_to :user, Wcsp.User

    timestamps()
  end

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, [:votes])
    |> assoc_constraint(:song)
    |> assoc_constraint(:user)
    |> assoc_constraint(:top)
    |> validate_number(:votes, greater_than: 0)
  end
end
