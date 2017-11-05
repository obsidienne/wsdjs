defmodule Wsdjs.ChartsTest do
  use Wsdjs.DataCase
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
    insert(:song, %{inserted_at: Timex.shift(dt, microseconds: 1), user: user, suggestion: false})
    insert(:song, %{inserted_at: Timex.shift(dt, days: 1, microseconds: 1), user: user, suggestion: false})
    insert(:song, %{inserted_at: dtend, user: user, suggestion: false})

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

    test "in published: Ranks has the correct position", %{top: top, positions: positions} do
      {:ok, top} = Charts.next_step(top)
      {:ok, top} = Charts.next_step(top)
      {:ok, top} = Charts.next_step(top)
      assert top.status == "published"

      ranks = Repo.all Ecto.assoc(top, :ranks)
      assert Enum.count(ranks) == 3
      Enum.each(ranks, fn rank ->
        position = Map.fetch!(positions, rank.song_id)
        assert rank.position == position
      end)
    end

    test "in counting from published: Ranks has no position", %{top: top} do
      {:ok, top} = Charts.next_step(top)
      {:ok, top} = Charts.next_step(top)
      {:ok, top} = Charts.next_step(top)
      {:ok, top} = Charts.previous_step(top)
      assert top.status == "counting"

      ranks = Repo.all Ecto.assoc(top, :ranks)
      assert Enum.count(ranks) == 3
      Enum.each(ranks, fn rank ->
        assert is_nil(rank.position)
      end)
    end
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

    # vote = 10 * vote[:count] - vote[:sum] + vote[:count]
    # opinion = "up"-> 4, "like" -> 2, "down" -> 3

    positions = %{
      "#{song1.id}" => 2,
      "#{song2.id}" => 1,
      "#{song3.id}" => 3,
    }

    user = insert(:user, %{admin: true})
    {:ok, %Top{} = top} = Charts.create_top(%{"due_date": Timex.today, user_id: user.id})

    insert(:vote, votes: 1, song: song1, top: top)
    insert(:vote, votes: 2, song: song2, top: top)
    insert(:vote, votes: 3, song: song3, top: top)

    %{top: top, positions: positions}
  end
end
