defmodule Dj.SongTest do
  use Dj.Case

  @valid_attrs %{title: "song title", artist: "the artist", url: "http://url.com", bpm: 120, genre: "pop"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Song.changeset(%Song{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Song.changeset(%Song{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "an artist can have multiple song" do
    assert false
  end

  test "different artist can have the same song title" do
    assert false
  end

  test "artist / title is unique" do
    assert false
  end

  test "bpm must be positive" do
    changeset = Song.changeset(%Song{}, %{@valid_attrs | bpm: -1})
    refute changeset.valid?
  end
end
