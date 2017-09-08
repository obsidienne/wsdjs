defmodule Wsdjs.TopTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Charts.Top
  import Wsdjs.Factory
  alias Wsdjs.Repo

  describe "changeset" do
    test "changeset with minimal valid attributes" do
      changeset = Top.changeset(%Top{}, params_for(:top))
      assert changeset.valid?
    end

    test "top owner accout must exist" do
      top = Top.changeset(%Top{}, params_for(:top, %{user_id: Ecto.UUID.generate()}))
      assert {:error, %{errors: [user: {"does not exist", _}]}} = Repo.insert(top)
    end
  end

  describe "Published top" do
    setup do
      [
        admin: insert(:user, %{admin: true}),
        dj_vip: insert(:user, %{profils: ["DJ_VIP"]}),
        dj: insert(:user, %{profils: ["DJ"]}),
        dt: Timex.beginning_of_month(Timex.today)
      ]
    end

    test "current month to n-3", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "published", due_date: context[:dt]}),
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -2)}),
      ]
      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end

    test "current month -3 to -6", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -3)}),
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -5)}),
      ]

      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end

    test "current month -6 to n-26", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -6)}),
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -26)})
      ]

      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end

    test "current month -27", context do
      top = insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -27)})

      assert [top] == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert [top] == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end
  end

  describe "Counting top" do
    setup do
      [
        admin: insert(:user, %{admin: true}),
        dj_vip: insert(:user, %{profils: ["DJ_VIP"]}),
        dj: insert(:user, %{profils: ["DJ"]}),
        dt: Timex.beginning_of_month(Timex.today)
      ]
    end

    test "current month to n-27", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "counting", due_date: context[:dt]}),
        insert(:top, %{user: context[:admin], status: "counting", due_date: Timex.shift(context[:dt], months: -2)}),
        insert(:top, %{user: context[:admin], status: "counting", due_date: Timex.shift(context[:dt], months: -3)}),
        insert(:top, %{user: context[:admin], status: "counting", due_date: Timex.shift(context[:dt], months: -5)}),
        insert(:top, %{user: context[:admin], status: "counting", due_date: Timex.shift(context[:dt], months: -6)}),
        insert(:top, %{user: context[:admin], status: "counting", due_date: Timex.shift(context[:dt], months: -26)}),
        insert(:top, %{user: context[:admin], status: "counting", due_date: Timex.shift(context[:dt], months: -27)})
      ]

      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end
  end

  describe "Voting top" do
    setup do
      [
        admin: insert(:user, %{admin: true}),
        dj_vip: insert(:user, %{profils: ["DJ_VIP"]}),
        dj: insert(:user, %{profils: ["DJ"]}),
        dt: Timex.beginning_of_month(Timex.today)
      ]
    end

    test "current month to n-27", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "voting", due_date: context[:dt]}),
        insert(:top, %{user: context[:admin], status: "voting", due_date: Timex.shift(context[:dt], months: -2)}),
        insert(:top, %{user: context[:admin], status: "voting", due_date: Timex.shift(context[:dt], months: -3)}),
        insert(:top, %{user: context[:admin], status: "voting", due_date: Timex.shift(context[:dt], months: -5)}),
        insert(:top, %{user: context[:admin], status: "voting", due_date: Timex.shift(context[:dt], months: -6)}),
        insert(:top, %{user: context[:admin], status: "voting", due_date: Timex.shift(context[:dt], months: -26)}),
        insert(:top, %{user: context[:admin], status: "voting", due_date: Timex.shift(context[:dt], months: -27)})
      ]

      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end
  end

  describe "Checking top" do
    setup do
      [
        admin: insert(:user, %{admin: true}),
        dj_vip: insert(:user, %{profils: ["DJ_VIP"]}),
        dj: insert(:user, %{profils: ["DJ"]}),
        dt: Timex.beginning_of_month(Timex.today)
      ]
    end

    test "current month to n-27", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "checking", due_date: context[:dt]}),
        insert(:top, %{user: context[:admin], status: "checking", due_date: Timex.shift(context[:dt], months: -2)}),
        insert(:top, %{user: context[:admin], status: "checking", due_date: Timex.shift(context[:dt], months: -3)}),
        insert(:top, %{user: context[:admin], status: "checking", due_date: Timex.shift(context[:dt], months: -5)}),
        insert(:top, %{user: context[:admin], status: "checking", due_date: Timex.shift(context[:dt], months: -6)}),
        insert(:top, %{user: context[:admin], status: "checking", due_date: Timex.shift(context[:dt], months: -26)}),
        insert(:top, %{user: context[:admin], status: "checking", due_date: Timex.shift(context[:dt], months: -27)})
      ]

      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end
  end


#    test "list_songs/0 returns all songs" do
#      song = song_fixture()
#      assert Musics.list_songs() == [song]
#    end

#    test "get_song!/1 returns the song with given id" do
#      song = song_fixture()
#      assert Musics.get_song!(song.id) == song
#    end

#    test "create_song/1 with valid data creates a song" do
#      assert {:ok, %Song{} = song} = Musics.create_song(@valid_attrs)
#      assert song.artist == "some artist"
#      assert song.title == "some title"
#    end

#    test "create_song/1 with invalid data returns error changeset" do
 #     assert {:error, %Ecto.Changeset{}} = Musics.create_song(@invalid_attrs)
  #  end

#    test "update_song/2 with valid data updates the song" do
#      song = song_fixture()
#      assert {:ok, song} = Musics.update_song(song, @update_attrs)
#      assert %Song{} = song
#      assert song.artist == "some updated artist"
#      assert song.title == "some updated title"
#    end

#    test "update_song/2 with invalid data returns error changeset" do
#      song = song_fixture()
#      assert {:error, %Ecto.Changeset{}} = Musics.update_song(song, @invalid_attrs)
#      assert song == Musics.get_song!(song.id)
#    end

#    test "delete_song/1 deletes the song" do
#      song = song_fixture()
#      assert {:ok, %Song{}} = Musics.delete_song(song)
#      assert_raise Ecto.NoResultsError, fn -> Musics.get_song!(song.id) end
#    end

#    test "change_song/1 returns a song changeset" do
#      song = song_fixture()
#      assert %Ecto.Changeset{} = Musics.change_song(song)
#    end
end
