defmodule Brididi.Charts.RankTest do
  use Brididi.DataCase, async: true

  alias Brididi.Charts.Rank
  alias Brididi.Repo
  import Brididi.AccountsFixtures

  test "rank song must exist" do
    attrs = rank_fixture_params()
    {:ok, dummy_id} = Brididi.HashID.load(999_999_999)

    params = %{top_id: attrs.top_id, song_id: dummy_id}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [song: {"does not exist", _}]}} = Repo.insert(rank)
  end

  test "rank top must exist" do
    attrs = rank_fixture_params()
    {:ok, dummy_id} = Brididi.HashID.load(999_999_999)

    params = %{top_id: dummy_id, song_id: attrs.song_id}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [top: {"does not exist", _}]}} = Repo.insert(rank)
  end

  test "votes can be equal to zero" do
    changeset = Rank.changeset(%Rank{}, rank_fixture_params(%{votes: 0}))
    assert changeset.valid?
  end

  defp rank_fixture_params(attrs \\ %{}) do
    user = user_fixture()
    {:ok, top} = Brididi.Charts.create_top(%{due_date: Timex.now(), user_id: user.id})

    {:ok, song} =
      Brididi.Musics.create_song(%{
        title: "a",
        artist: "a",
        genre: "soul",
        url: "http://t.a.com",
        user_id: user.id
      })

    attrs
    |> Map.put(:user_id, user.id)
    |> Map.put(:top_id, top.id)
    |> Map.put(:song_id, song.id)
  end
end
