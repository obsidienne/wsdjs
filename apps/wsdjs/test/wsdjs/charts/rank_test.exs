defmodule Wsdjs.Charts.RankTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Charts.Rank
  import Wsdjs.Factory
  alias Wsdjs.Repo

  test "rank song must exist" do
    top = insert(:top)
    params = %{top_id: top.id, song_id: Ecto.UUID.generate()}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [song: {"does not exist", _}]}} = Repo.insert(rank)
  end

  test "rank top must exist" do
    song = insert(:song)
    params = %{top_id: Ecto.UUID.generate(), song_id: song.id}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [top: {"does not exist", _}]}} = Repo.insert(rank)
  end

  test "rank/song/top combinaison is unique" do
    changeset = Rank.changeset(%Rank{}, params_with_assocs(:rank))
    Repo.insert(changeset)
    {:error, changeset} = Repo.insert(changeset)
    assert "has already been taken" in errors_on(changeset).song_id
  end

  test "votes/bonus can be equal to zero" do
    changeset = Rank.changeset(%Rank{}, params_for(:rank, %{votes: 0, bonus: 0}))
    assert changeset.valid?
  end
end
