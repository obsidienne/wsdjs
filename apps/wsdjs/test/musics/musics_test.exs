defmodule Wsdjs.MusicsTest do
  use Wsdjs.DataCase

  alias Wsdjs.Musics

  @create_attrs %{title: "song title", artist: "the artist", url: "http://song-url.com", genre: "pop"}

  def fixture(:songs, user, attrs \\ @create_attrs) do
    {:ok, songs} = Musics.create_song(user, attrs)
    songs
  end

  test "list_song/1 returns all song" do
    {:ok, user} = Wsdjs.Accounts.create_user(%{email: "test#{System.unique_integer()}@testing.com"})
    songs = fixture(:songs, user)
    assert Musics.list_songs(user) == [songs]
  end
end
