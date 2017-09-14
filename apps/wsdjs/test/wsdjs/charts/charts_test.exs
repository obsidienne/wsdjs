defmodule Wsdjs.ChartsTest do
  use Wsdjs.DataCase, async: true
  import Wsdjs.Factory

  alias Wsdjs.Charts
  alias Wsdjs.Charts.Top

  test "Create TOP, Song are selected according to month" do
    dt = Timex.beginning_of_month(Timex.now)
    dtend = Timex.end_of_month(Timex.now)
    user = insert(:user, profil_djvip: true)

    insert(:song, %{inserted_at: Timex.to_datetime(Timex.shift(dt, seconds: -1))})
    insert(:song, %{inserted_at: Timex.shift(dtend, seconds: 1)})
    song_in = [
      insert(:song, %{inserted_at: Timex.shift(dt, microseconds: 1), user: user}),
      insert(:song, %{inserted_at: Timex.shift(dt, days: 1, microseconds: 1), user: user}),
      insert(:song, %{inserted_at: dtend, user: user}),
    ]

    user = insert(:user, %{admin: true})
    {:ok, %Top{} = top} = Charts.create_top(%{"due_date": Timex.today, user_id: user.id})
    assert Enum.count(top.songs) == 3
    assert song_in == top.songs |> Repo.preload(:user)
  end

  describe "TOP" do
    setup :create_top

    test "in checking: Ranks are without values", %{top: top} do
      assert top.status == "checking"

      ranks = Repo.all Ecto.assoc(top, :ranks)
      assert Enum.count(ranks) == 3

      Enum.each(ranks, fn rank ->
        assert rank.likes == 0
        assert rank.votes == 0
        assert rank.bonus == 0
        assert is_nil(rank.position)
      end)
    end

    test "in voting: Ranks are without values", %{top: top} do
      {:ok, top_updated} = Charts.next_step(top)
      assert top_updated.status == "voting"

      ranks = Repo.all Ecto.assoc(top_updated, :ranks)
      assert Enum.count(ranks) == 3
      Enum.each(ranks, fn rank ->
        assert rank.likes == 0
        assert rank.votes == 0
        assert rank.bonus == 0
        assert is_nil(rank.position)
      end)
    end

    test "in counting: Ranks has values", %{top: top} do
      {:ok, top_updated} = Charts.next_step(top)
      {:ok, top_updated} = Charts.next_step(top_updated)
      assert top_updated.status == "counting"

      ranks = Repo.all Ecto.assoc(top_updated, :ranks)
      assert Enum.count(ranks) == 3

      Enum.each(ranks, fn rank ->
        refute rank.likes == 0
        refute rank.votes == 0
        assert rank.bonus == 0
        assert is_nil(rank.position)
      end)
    end
  end

  test "Votes are correctly summed" do
    assert false
  end

  defp create_top(_) do
    dt = Timex.beginning_of_month(Timex.now)
    dtend = Timex.end_of_month(Timex.now)

    song1 = insert(:song, %{inserted_at: dt})
    song2 = insert(:song, %{inserted_at: Timex.shift(dt, days: 1)})
    song3 = insert(:song, %{inserted_at: dtend})

    insert(:opinion, song: song1, kind: "like")
    insert(:opinion, song: song2, kind: "up")
    insert(:opinion, song: song3, kind: "down")

    user = insert(:user, %{admin: true})
    {:ok, %Top{} = top} = Charts.create_top(%{"due_date": Timex.today, user_id: user.id})

    insert(:vote, votes: 1, song: song1, top: top)
    insert(:vote, votes: 2, song: song2, top: top)
    insert(:vote, votes: 3, song: song3, top: top)

    %{top: top}
  end
end
