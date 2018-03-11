defmodule Wsdjs.MusicsTest do
  use Wsdjs.DataCase
  alias Wsdjs.Musics
  alias Wsdjs.Repo

  describe "songs" do
    alias Wsdjs.Musics.Song
    alias Wsdjs.Accounts.User

    @valid_attrs %{
      title: "my title",
      artist: "my artist",
      genre: "soul",
      url: "http://youtu.be/dummy"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, %Wsdjs.Accounts.User{} = user} =
        attrs
        |> Enum.into(%{email: "dummy#{System.unique_integer([:positive])}@bshit.com"})
        |> Wsdjs.Accounts.create_user()

      user
    end

    def song_fixture(attrs \\ %{}) do
      {:ok, %Song{} = song} = Musics.create_suggestion(song_params(attrs))
      song
    end

    def song_params(attrs \\ %{}) do
      user = user_fixture()

      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:user_id, user.id)
    end

    test "instant_hits/0 returns all instant hit" do
      song = song_fixture()
      {:ok, %Song{} = song} = Musics.update_song(song, %{instant_hit: true}, %User{admin: true})
      song = Repo.preload(song, [:art, :comments, :opinions, user: :avatar])
      assert Musics.instant_hits() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture() |> Repo.preload([:art, :user])
      assert Musics.get_song!(song.id) == song
    end

    test "get_song_by!/2 returns the song with given artist and title" do
      song = song_fixture() |> Repo.preload([:art, :user, tops: :ranks])
      assert Musics.get_song_by("my artist", "my title") == song
    end

    test "create_suggestion/1 with valid data suggest a song" do
      user = user_fixture()
      params = Map.put(@valid_attrs, :user_id, user.id)

      assert {:ok, %Song{} = song} = Musics.create_suggestion(params)
      assert song.artist == params.artist
      assert song.title == params.title
      assert song.url == params.url
      assert song.bpm == 0
      assert song.instant_hit == false
      assert song.hidden_track == false
      assert song.public_track == false
      assert song.suggestion == true
    end

    test "create_song/1 with valid data creates a song" do
      user = user_fixture()
      params = Map.put(@valid_attrs, :user_id, user.id)

      assert {:ok, %Song{} = song} = Musics.create_song(params)
      assert song.artist == params.artist
      assert song.title == params.title
      assert song.url == params.url
      assert song.bpm == 0
      assert song.instant_hit == false
      assert song.hidden_track == false
      assert song.public_track == false
      assert song.suggestion == false
    end

    test "create_song/1 with invalid data returns error changeset" do
      params = Map.put(@valid_attrs, :user_id, Ecto.UUID.generate())
      assert {:error, %Ecto.Changeset{} = changeset} = Musics.create_song(params)
      assert "does not exist" in errors_on(changeset).user

      assert {:error, %Ecto.Changeset{} = changeset} = Musics.create_song(song_params(bpm: -1))
      assert "must be greater than 0" in errors_on(changeset).bpm

      assert {:error, %Ecto.Changeset{} = changeset} = Musics.create_song(song_params(title: nil))
      assert "can't be blank" in errors_on(changeset).title

      assert {:error, %Ecto.Changeset{} = changeset} =
               Musics.create_song(song_params(artist: nil))

      assert "can't be blank" in errors_on(changeset).artist

      assert {:error, %Ecto.Changeset{} = changeset} =
               Musics.create_song(song_params(url: "bullshit"))

      assert "invalid url: :no_scheme" in errors_on(changeset).url

      params = song_params()
      assert {:ok, %Song{}} = Musics.create_song(params)
      assert {:error, %Ecto.Changeset{} = changeset} = Musics.create_song(params)
      assert "has already been taken" in errors_on(changeset).title
    end

    @update_attrs %{
      title: "update title",
      artist: "update artist",
      url: "http://youtube.com/update_url",
      bpm: 333,
      genre: "rnb",
      instant_hit: true,
      hidden_track: true,
      public_track: true,
      suggestion: false
    }

    test "update_song/3 with valid data done by admin updates the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = Musics.update_song(song, @update_attrs, %User{admin: true})
      assert song.title == "update title"
      assert song.artist == "update artist"
      assert song.bpm == 333
      assert song.url == "http://youtube.com/update_url"
      assert song.genre == "rnb"
      assert song.instant_hit == true
      assert song.hidden_track == true
      assert song.public_track == true
      assert song.suggestion == false
    end

    test "update_song/3 with valid data done by user updates the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = Musics.update_song(song, @update_attrs, %User{admin: false})
      assert song.title == "my title"
      assert song.artist == "my artist"
      assert song.bpm == 333
      assert song.url == "http://youtube.com/update_url"
      assert song.genre == "rnb"
      assert song.instant_hit == false
      assert song.hidden_track == true
      assert song.public_track == true
      assert song.suggestion == true
    end

    test "update_song/3 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Musics.update_song(song, %{bpm: -1}, %User{})
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = Musics.delete_song(song)
      assert_raise Ecto.NoResultsError, fn -> Musics.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Musics.change_song(song)
    end
  end
end
