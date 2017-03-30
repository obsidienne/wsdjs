defmodule Wcsp.RankSong do
  @moduledoc """
  This is the RankSong module. It aims to store a DJ vote:
  The votes is the position of the song between 1 and count(ranks) for top)

  position: filled and freezed in publish
  """
  use Wcsp.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rank_songs" do
    field :votes, :integer

    belongs_to :song, Wcsp.Musics.Song
    belongs_to :top, Wcsp.Top
    belongs_to :user, Wcsp.Accounts.User

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

  def build(%{user_id: _user_id, song_id: _song_id, votes: _votes} = params) do
    changeset(%Wcsp.RankSong{}, params)
  end

  def get_or_build(top, user_id, song_id, votes) do
    struct =
      Repo.get_by(Wcsp.RankSong, user_id: user_id, top_id: top.id, song_id: song_id) ||
      Ecto.build_assoc(top, :rank_songs, user_id: user_id, song_id: song_id)

    Ecto.Changeset.change(struct, votes: String.to_integer(votes))
  end

  def for_user_and_top(top, user) do
    from r in Wcsp.RankSong,
    where: r.user_id == ^user.id and r.top_id == ^top.id
  end
end
