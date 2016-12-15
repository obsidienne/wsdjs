defmodule Dj.SongTest do
  use Dj.Case

  defp errors_on(model, params) do
    model.__struct__.changeset(model, params).errors
  end

  @valid_attrs %{title: "song title", artist: "the artist"}

  test "changeset with valid attributes" do
    changeset = Song.changeset(%Song{}, @valid_attrs)
    assert changeset.valid?
  end

  test "artist / title is unique" do
    assert false
  end

  test "bpm must be positive" do
    assert {:bpm, {"must be greater than %{number}", [number: 0]}} in errors_on(%Song{}, %{bpm: -1})
  end

  test "title can't be blank" do
    assert {:title, {"can't be blank", []}} in errors_on(%Song{}, %{title: nil})
  end

  test "artist can't be blank" do
    assert {:artist, {"can't be blank", []}} in errors_on(%Song{}, %{artist: nil})
  end

  test "url must be valid" do
    assert {:url, {"invalid url: :no_scheme", []}} in errors_on(%Song{}, %{url: "bullshit"})
  end
end
