defmodule Wsdjs.TopTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Charts.Top
  alias Wsdjs.Charts
  alias Wsdjs.Repo

  import Wsdjs.Factory

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
        dj_vip: insert(:user, %{profil_djvip: true}),
        dj: insert(:user, %{profil_dj: true}),
        dt: Timex.beginning_of_month(Timex.today)
      ]
    end

    test "[current month, n-2]", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "published", due_date: context[:dt]}),
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -2)}),
      ]
      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end

    test "[current month -3 to -5]", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -3)}),
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -5)}),
      ]

      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end

    test "[current month -6 to n-24]", context do
      tops = [
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -6)}),
        insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -24)})
      ]

      assert tops == Top.scoped(context[:admin]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj_vip]) |> Repo.all() |> Repo.preload(:user)
      assert tops == Top.scoped(context[:dj]) |> Repo.all() |> Repo.preload(:user)
      assert [] == Top.scoped(nil) |> Repo.all() |> Repo.preload(:user)
    end

    test "current month -25", context do
      top = insert(:top, %{user: context[:admin], status: "published", due_date: Timex.shift(context[:dt], months: -25)})

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
        dj_vip: insert(:user, %{profil_djvip: true}),
        dj: insert(:user, %{profil_dj: true}),
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
        dj_vip: insert(:user, %{profil_djvip: true}),
        dj: insert(:user, %{profil_dj: true}),
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
        dj_vip: insert(:user, %{profil_djvip: true}),
        dj: insert(:user, %{profil_dj: true}),
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

  test "get_top!/1 returns the top with given id" do
    top = insert(:top)
    assert top == Charts.get_top!(top.id) |> Repo.preload(:user)
  end

  test "create_top/1 with valid data creates a top" do
    user = insert(:user)
    params = params_for(:top, %{user_id: user.id})
    assert {:ok, %Top{} = top} = Charts.create_top(params)
    assert top.due_date == params[:due_date]
  end

#    test "create_song/1 with invalid data returns error changeset" do
 #     assert {:error, %Ecto.Changeset{}} = Musics.create_song(@invalid_attrs)
  #  end

  # test "update_top/2 with valid data updates the top" do
  #   top = insert(:top)
  #   assert {:ok, top} = Charts.update_top(top, %{})
  #   assert %Song{} = song
  #   assert song.artist == "some updated artist"
  #   assert song.title == "some updated title"
  # end

#    test "update_song/2 with invalid data returns error changeset" do
#      song = song_fixture()
#      assert {:error, %Ecto.Changeset{}} = Musics.update_song(song, @invalid_attrs)
#      assert song == Musics.get_song!(song.id)
#    end

  test "delete_top/1 deletes the top" do
    top = insert(:top)
    assert {:ok, %Top{}} = Charts.delete_top(top)
    assert_raise Ecto.NoResultsError, fn -> Charts.get_top!(top.id) end
  end

#    test "change_song/1 returns a song changeset" do
#      song = song_fixture()
#      assert %Ecto.Changeset{} = Musics.change_song(song)
#    end
end
