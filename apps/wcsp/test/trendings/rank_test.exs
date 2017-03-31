defmodule Wcsp.RankTest do
  use Wcsp.DataCase, async: true

  alias Wcsp.Trendings.Rank

  test "rank song must exist" do
    params = %{top_id: Ecto.UUID.generate(),song_id: Ecto.UUID.generate()}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [song: {"does not exist", _}]}} = Repo.insert(rank)
  end
end
