defmodule Wsdjs.Charts.RankTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Charts.Rank
  alias Wsdjs.Repo

  test "rank song must exist" do
    attrs = rank_fixture_params()
    {:ok, dummy_id} = Wsdjs.HashID.load(999_999_999)

    params = %{top_id: attrs.top_id, song_id: dummy_id}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [song: {"does not exist", _}]}} = Repo.insert(rank)
  end

  test "rank top must exist" do
    attrs = rank_fixture_params()
    {:ok, dummy_id} = Wsdjs.HashID.load(999_999_999)

    params = %{top_id: dummy_id, song_id: attrs.song_id}
    rank = Rank.changeset(%Rank{}, params)
    assert {:error, %{errors: [top: {"does not exist", _}]}} = Repo.insert(rank)
  end

  test "votes/bonus can be equal to zero" do
    changeset = Rank.changeset(%Rank{}, rank_fixture_params(%{votes: 0, bonus: 0}))
    assert changeset.valid?
  end

  defp rank_fixture_params(attrs \\ %{}) do
    {:ok, user} = Wsdjs.Accounts.create_user(%{email: "dummy@bshit.com"})
    {:ok, top} = Wsdjs.Charts.create_top(%{due_date: Timex.now(), user_id: user.id})

    {:ok, song} =
      Wsdjs.Musics.Songs.create_song(%{
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
