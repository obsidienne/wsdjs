defmodule Wsdjs.ChartsTest do
  use Wsdjs.DataCase

  alias Wsdjs.Charts
  alias Wsdjs.Charts.Top

  test "Create TOP, Song are selected according to month" do
    dt = Timex.beginning_of_month(Timex.now())
    dtend = Timex.end_of_month(Timex.now())

    song_fixture(%{inserted_at: Timex.to_datetime(Timex.shift(dt, seconds: -1))})
    song_fixture(%{inserted_at: Timex.shift(dtend, seconds: 1)})

    song_in = [
      song_fixture(%{inserted_at: Timex.shift(dt, microseconds: 1)}),
      song_fixture(%{inserted_at: Timex.shift(dt, days: 1, microseconds: 1)}),
      song_fixture(%{inserted_at: dtend})
    ]

    song_fixture(%{inserted_at: Timex.shift(dt, microseconds: 1), suggestion: false})
    song_fixture(%{inserted_at: Timex.shift(dt, days: 1, microseconds: 1), suggestion: false})
    song_fixture(%{inserted_at: dtend, suggestion: false})

    user = user_fixture()
    {:ok, %Top{} = top} = Charts.create_top(%{due_date: Timex.today(), user_id: user.id})
    assert Enum.count(top.songs) == 3
    assert Enum.sort(song_in) == Enum.sort(top.songs)
  end

  describe "TOP" do
    setup :create_top

    test "in checking: Ranks are without values", %{top: top} do
      assert top.status == "checking"

      ranks = Repo.all(Ecto.assoc(top, :ranks))
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

      ranks = Repo.all(Ecto.assoc(top_updated, :ranks))
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

      ranks = Repo.all(Ecto.assoc(top_updated, :ranks))
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

      ranks = Repo.all(Ecto.assoc(top, :ranks))
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

      ranks = Repo.all(Ecto.assoc(top, :ranks))
      assert Enum.count(ranks) == 3

      Enum.each(ranks, fn rank ->
        assert is_nil(rank.position)
      end)
    end
  end

  defp song_fixture(attrs) do
    user = user_fixture()

    {:ok, %Wsdjs.Musics.Song{} = song} =
      %{
        title: "my title#{System.unique_integer([:positive])}",
        artist: "my artist",
        genre: "soul",
        url: "http://youtu.be/dummy"
      }
      |> Map.put(:user_id, user.id)
      |> Wsdjs.Musics.create_suggestion()

    {:ok, %Wsdjs.Musics.Song{} = song} =
      Wsdjs.Musics.update_song(song, attrs, %Wsdjs.Accounts.User{admin: true})

    song
  end

  defp user_fixture() do
    {:ok, %Wsdjs.Accounts.User{} = user} =
      Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

    user
  end

  defp create_top(_) do
    dt = Timex.beginning_of_month(Timex.now())
    dtend = Timex.end_of_month(Timex.now())

    song1 = song_fixture(%{inserted_at: dt})
    song2 = song_fixture(%{inserted_at: Timex.shift(dt, days: 1)})
    song3 = song_fixture(%{inserted_at: dtend})

    user = user_fixture()
    {:ok, %Wsdjs.Reactions.Opinion{}} = Wsdjs.Reactions.upsert_opinion(user, song1, "like")
    {:ok, %Wsdjs.Reactions.Opinion{}} = Wsdjs.Reactions.upsert_opinion(user, song2, "up")
    {:ok, %Wsdjs.Reactions.Opinion{}} = Wsdjs.Reactions.upsert_opinion(user, song3, "down")

    # vote = 10 * vote[:count] - vote[:sum] + vote[:count]
    # opinion = "up"-> 4, "like" -> 2, "down" -> 3

    positions = %{
      "#{song1.id}" => 2,
      "#{song2.id}" => 1,
      "#{song3.id}" => 3
    }

    user = user_fixture()
    {:ok, %Top{} = top} = Charts.create_top(%{due_date: Timex.today(), user_id: user.id})

    Wsdjs.Charts.vote(user, %{
      "top_id" => top.id,
      "votes" => %{
        song1.id => "1",
        song2.id => "2",
        song3.id => "3"
      }
    })

    %{top: top, positions: positions}
  end
end
