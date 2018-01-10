defmodule Wsdjs.Playlists.PlaylistsTest do
  use Wsdjs.DataCase
  alias Wsdjs.Playlists

  describe "playlists" do
    alias Wsdjs.Playlists.Playlist
    
    @valid_attrs %{name: "playlist name"}
    @update_attrs %{name: "new playlist name"}
    @invalid_attrs %{name: ""}

    def playlist_fixture(attrs \\ %{}) do
      {:ok, playlist} = Playlists.create_playlist(playlist_fixture_attrs(attrs))

      playlist
    end

    def playlist_fixture_attrs(attrs \\ %{}) do
      {:ok, user} = Wsdjs.Accounts.create_user(%{email: "dummy#{System.unique_integer()}@bshit.com"})

      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:user_id, user.id)
    end

    test "list_playlists/0 returns all playlists" do
      playlist = playlist_fixture()
      assert Playlists.list_playlists() == [playlist]
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
    end

    test "update_playlist/2 with valid data updates the playlist" do
      playlist = playlist_fixture()

      assert {:ok, playlist} = Playlists.update_playlist(playlist, @update_attrs)
      assert %Playlist{} = playlist
      assert playlist.name == "new playlist name"
    end

    test "update_playlist/2 with invalid data returns error changeset" do
      playlist = playlist_fixture()
      
      assert {:error, %Ecto.Changeset{}} = Playlists.update_playlist(playlist, @invalid_attrs)
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
end
