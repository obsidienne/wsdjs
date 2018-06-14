defmodule Wsdjs.Playlists.PlaylistsTest do
  use Wsdjs.DataCase
  alias Wsdjs.Accounts
  alias Wsdjs.Playlists

  describe "playlists" do
    alias Wsdjs.Playlists.Playlist

    @valid_attrs %{name: "playlist name"}
    @update_attrs %{name: "new playlist name"}
    @invalid_attrs %{name: ""}

    def playlist_fixture(user) do
      {:ok, playlist} = Playlists.create_playlist(%{name: "playlist name", user_id: user.id})

      playlist
    end

    def playlist_fixture() do
      {:ok, user} =
        Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      {:ok, playlist} = Playlists.create_playlist(%{name: "playlist name", user_id: user.id})

      playlist
    end

    def user_fixture() do
      {:ok, user} =
        Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      user
    end

    def playlist_fixture_attrs(attrs \\ %{}) do
      {:ok, user} =
        Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:user_id, user.id)
    end

    test "list_playlists/1 returns all playlists" do
      user = user_fixture()

      playlist = playlist_fixture(user) |> Repo.preload(song: :art)
      assert Playlists.list_playlists(user, user) == [playlist]
    end

    test "get_playlist!/1 returns the playlist with given id" do
      playlist = playlist_fixture()
      assert Playlists.get_playlist!(playlist.id) == playlist
    end

    test "create_playlist/1 with valid data creates a playlist" do
      assert {:ok, %Playlist{} = playlist} = Playlists.create_playlist(playlist_fixture_attrs())
      assert playlist.name == "playlist name"
    end

    test "create_playlist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Playlists.create_playlist(@invalid_attrs)

      assert {:error, %Ecto.Changeset{} = changeset} = Playlists.create_playlist(%{name: ""})
      assert "can't be blank" in errors_on(changeset).name

      assert {:error, %Ecto.Changeset{} = changeset} = Playlists.create_playlist(%{name: " "})
      assert "can't be blank" in errors_on(changeset).name

      assert {:error, %Ecto.Changeset{} = changeset} =
               Playlists.create_playlist(%{name: "test", user_id: Ecto.UUID.generate()})

      assert "does not exist" in errors_on(changeset).user

      attrs = playlist_fixture_attrs()
      assert {:ok, %Playlist{}} = Playlists.create_playlist(attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = Playlists.create_playlist(attrs)
      assert "has already been taken" in errors_on(changeset).name
    end

    test "update_playlist/2 with valid data updates the playlist" do
      playlist = playlist_fixture()

      assert {:ok, playlist} =
               Playlists.update_playlist(playlist, @update_attrs, %Accounts.User{})

      assert %Playlist{} = playlist
      assert playlist.name == "new playlist name"
    end

    test "update_playlist/2 with invalid data returns error changeset" do
      playlist = playlist_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Playlists.update_playlist(playlist, @invalid_attrs, %Accounts.User{})

      assert playlist == Playlists.get_playlist!(playlist.id)
    end

    test "delete_playlist/1 deletes the playlist" do
      playlist = playlist_fixture()
      assert {:ok, %Playlist{}} = Playlists.delete_playlist(playlist)
      assert_raise Ecto.NoResultsError, fn -> Playlists.get_playlist!(playlist.id) end
    end

    test "change_playlist/1 returns a playlist changeset" do
      playlist = playlist_fixture()
      assert %Ecto.Changeset{} = Playlists.change_playlist(playlist)
    end
  end

  describe "playlist_songs" do
    alias Wsdjs.Playlists.Playlist

    def song_fixture(user_id) do
      {:ok, %Wsdjs.Musics.Song{} = song} =
        %{
          title: "my title#{System.unique_integer([:positive])}",
          artist: "my artist",
          genre: "soul",
          url: "http://youtu.be/dummy"
        }
        |> Map.put(:user_id, user_id)
        |> Wsdjs.Musics.create_suggestion()

      song
    end

    def playlist_with_songs_fixture() do
      {:ok, user} =
        Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      {:ok, playlist} =
        Playlists.create_playlist(%{name: "dummy#{System.unique_integer()}", user_id: user.id})

      playlist = playlist |> Repo.preload(song: :art)

      song1 = song_fixture(user.id)
      song2 = song_fixture(user.id)
      song3 = song_fixture(user.id)

      Wsdjs.Playlists.update_playlist_songs(playlist, %{
        song1.id => "1",
        song2.id => "2",
        song3.id => "3"
      })

      %{user: user, playlist: playlist, songs: [song1, song2, song3]}
    end

    test "list_playlist_songs/1 returns all song in the playlist" do
      %{user: user, playlist: playlist, songs: songs} = playlist_with_songs_fixture()
      assert Playlists.list_playlists(user, user) == [playlist]
      assert Playlists.list_playlist_songs(playlist, user) == songs |> Repo.preload(:art)
    end
  end
end
