defmodule Brididi.ChartsTest do
  use Brididi.DataCase

  alias Brididi.Charts
  alias Brididi.Charts.Top

  import Brididi.AccountsFixtures

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

    user = user_fixture()

    {:ok, %Top{} = top} =
      Charts.create_top(%{
        start_date: Date.beginning_of_month(Date.utc_today()),
        end_date: Date.end_of_month(Date.utc_today()),
        user_id: user.id
      })

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
        assert is_nil(rank.position)
      end)
    end

    test "in published: Ranks has the correct position", %{top: top, positions: positions} do
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
  end

  defp song_fixture(attrs) do
    user = user_fixture()

    {:ok, song} =
      %{
        "title" => "my title#{System.unique_integer([:positive])}",
        "artist" => "my artist",
        "genre" => "soul",
        "url" => "http://youtu.be/dummy"
      }
      |> Map.put("user_id", user.id)
      |> Brididi.Musics.create_song()

    {:ok, song} = Brididi.Musics.update(song, attrs)
    song
  end

  defp create_top(_) do
    dt = Timex.beginning_of_month(Timex.now())
    dtend = Timex.end_of_month(Timex.now())

    song1 = song_fixture(%{inserted_at: dt})
    song2 = song_fixture(%{inserted_at: Timex.shift(dt, days: 1)})
    song3 = song_fixture(%{inserted_at: dtend})

    user = user_fixture()

    {:ok, _} = Brididi.Reactions.Opinions.upsert(user, song1, "like")
    {:ok, _} = Brididi.Reactions.Opinions.upsert(user, song2, "up")
    {:ok, _} = Brididi.Reactions.Opinions.upsert(user, song3, "down")

    # vote = 10 * vote[:count] - vote[:sum] + vote[:count]
    # opinion = "up"-> 4, "like" -> 2, "down" -> 3

    positions = %{
      "#{song1.id}" => 2,
      "#{song2.id}" => 1,
      "#{song3.id}" => 3
    }

    user = user_fixture()

    {:ok, %Top{} = top} =
      Charts.create_top(%{
        start_date: Date.beginning_of_month(Date.utc_today()),
        end_date: Date.end_of_month(Date.utc_today()),
        user_id: user.id
      })

    Brididi.Charts.vote(user, %{
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
