defmodule Wsdjs.MusicsTest do
  use Wsdjs.DataCase
  import Wsdjs.Factory
  alias Wsdjs.Musics
  alias Wsdjs.Musics.Song
  alias Wsdjs.Repo

  describe "songs" do
    alias Wsdjs.Accounts
    alias Wsdjs.Accounts.User
    
    @valid_attrs %{title: "my title", artist: "my artist", genre: "soul", url: "http://youtu.be/dummy"}

    def user_fixture(attrs \\ %{}) do
      {:ok, %User{} = user} =
        attrs
        |> Enum.into(%{email: "dummy@bshit.com"})
        |> Accounts.create_user()

      user
    end

    def song_fixture(attrs \\ %{}) do
      user = user_fixture()

      {:ok, %Song{} = song} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:user_id, user.id)
        |> Musics.create_song()

      song
    end

    test "instant_hits/0 returns all instant hit" do
      song = song_fixture(%{instant_hit: true})
      |> Repo.preload([:art, :comments, :opinions, user: :avatar])
      assert Musics.instant_hits() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture() |> Repo.preload([:art, :user])
      assert Musics.get_song!(song.id) == song
    end

    test "create_song/1 with valid data creates a song" do
      user = insert(:user)
      params = params_for(:song, %{user_id: user.id})

      assert {:ok, %Song{} = song} = Musics.create_song(params)
      assert song.artist == params.artist
      assert song.title == params.title
    end

    test "create_song/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Musics.create_song(%{})
    end

    test "update_song/2 with valid data updates the song" do
      song = insert(:song)
      assert {:ok, song} = Musics.update_song(song, %{title: "new title"})
      assert %Song{} = song
      assert song.title == "new title"
    end

    test "update_song/2 with invalid data returns error changeset" do
      song = insert(:song)
      assert {:error, %Ecto.Changeset{}} = Musics.update_song(song, %{bpm: -1})
      assert Musics.get_song!(song.id) == song |> Repo.preload(:art)
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{}} = Musics.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Musics.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Musics.change_song(song)
    end
  end
end
