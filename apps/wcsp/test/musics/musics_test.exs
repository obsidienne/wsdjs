defmodule Wcsp.MusicTest do
  use Wcsp.DataCase

#  doctest Wcsp.Music

  alias Wcsp.Musics

  @create_attrs %{title: "song title", artist: "the artist", url: "http://song_url.com", genre: "pop"}

  def fixture(:songs, attrs \\ @create_attrs) do
    {:ok, songs} = Musics.create_songs(attrs)
    songs
  end

  test "list_song/1 returns all song" do
    songs = fixture(:songs)
    assert Musics.list_song() == [songs]
  end
end
