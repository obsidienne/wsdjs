defmodule Wsdjs.RankTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Charts.Rank

  test "rank song must exist" do
    params = %{top_id: Ecto.UUID.generate(),song_id: Ecto.UUID.generate()}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [song: {"does not exist", _}]}} = Repo.insert(rank)
  end
end
