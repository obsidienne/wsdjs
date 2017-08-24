defmodule Wsdjs.TopTest do
  use Wsdjs.DataCase, async: true

  alias Wsdjs.Charts.Top
  import Wsdjs.Factory

  describe "changeset" do
    @create_attrs %{status: "checking", due_date: "2012-06-30"}

    test "changeset with minimal valid attributes" do
      changeset = Top.changeset(%Top{}, @create_attrs)
      assert changeset.valid?
    end

    test "top owner accout must exist" do
      params = Map.put(@create_attrs, :user_id, Ecto.UUID.generate())
      top = Top.changeset(%Top{}, params)
      assert {:error, %{errors: [user: {"does not exist", _}]}} = Repo.insert(top)
    end
  end

  describe "Top.scoped(%User{admin: true})" do
    test "published" do
      user = insert!(:user, %{admin: true})
      tops = Enum.map(-1..-28, &create_top("published", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 28
      assert scoped == tops
    end

    test "counting" do
      user = insert!(:user, %{admin: true})
      tops = Enum.map(-1..-28, &create_top("counting", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 28
      assert scoped == tops
    end

    test "voting" do
      user = insert!(:user, %{admin: true})
      tops = Enum.map(-1..-28, &create_top("voting", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 28
      assert scoped == tops
    end

    test "checking" do
      user = insert!(:user, %{admin: true})
      tops = Enum.map(-1..-28, &create_top("checking", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 28
      assert scoped == tops
    end
  end

  describe "Top.scoped(%User{profils: DJ_VIP})" do
    test "published" do
      user = insert!(:user, %{profils: ["DJ_VIP"]})
      tops = Enum.map(-1..-28, &create_top("published", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 28
      assert scoped == tops
    end

    test "counting" do
      user = insert!(:user, %{profils: ["DJ_VIP"]})
      Enum.each(-1..-28, &create_top("counting", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 0
    end

    test "voting" do
      user = insert!(:user, %{profils: ["DJ_VIP"]})
      tops = Enum.map(-1..-28, &create_top("voting", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 28
      assert scoped == tops
    end

    test "checking" do
      user = insert!(:user, %{profils: ["DJ_VIP"]})
      Enum.each(-1..-28, &create_top("checking", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 0
    end
  end

  describe "Top.scoped(%User{profils: DJ})" do
    test "published" do
      user = insert!(:user, %{profils: ["DJ"]})
      tops = Enum.map(-1..-28, &create_top("published", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 24
      assert scoped == Enum.slice(tops, 2, 24)
    end

    test "counting" do
      user = insert!(:user, %{profils: ["DJ"]})
      Enum.each(-1..-28, &create_top("counting", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 0
    end

    test "voting" do
      user = insert!(:user, %{profils: ["DJ"]})
      Enum.each(-1..-28, &create_top("voting", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 0
    end

    test "checking" do
      user = insert!(:user, %{profils: ["DJ"]})
      Enum.each(-1..-28, &create_top("checking", &1))

      scoped = Top.scoped(user) |> Repo.all()
      assert Enum.count(scoped) == 0
    end
  end

  describe "Top.scoped(nil)" do
    test "published" do
      tops = Enum.map(-1..-28, &create_top("published", &1))

      scoped = Top.scoped(nil) |> Repo.all()
      assert Enum.count(scoped) == 3
      assert scoped == Enum.slice(tops, 2, 3)
    end

    test "counting" do
      Enum.each(-1..-28, &create_top("counting", &1))

      scoped = Top.scoped(nil) |> Repo.all()
      assert Enum.count(scoped) == 0
    end

    test "voting" do
      Enum.each(-1..-28, &create_top("voting", &1))

      scoped = Top.scoped(nil) |> Repo.all()
      assert Enum.count(scoped) == 0
    end

    test "checking" do
      Enum.each(-1..-28, &create_top("checking", &1))

      scoped = Top.scoped(nil) |> Repo.all()
      assert Enum.count(scoped) == 0
    end
  end

  defp create_top(status, shift) do
    admin = insert!(:user, %{admin: true})

    dt = Timex.today
    |> Timex.beginning_of_month()
    |> Timex.shift(months: shift)
    insert!(:top, %{user_id: admin.id, status: status, due_date: dt})
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
