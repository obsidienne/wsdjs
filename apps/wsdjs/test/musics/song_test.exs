defmodule Wsdjs.SongTest do
  use Wsdjs.DataCase, async: true
  import Wsdjs.Factory

  alias Wsdjs.Musics.Song

  @create_attrs %{title: "song title", artist: "the artist", url: "http://song_url.com", genre: "pop"}

  test "changeset with minimal valid attributes" do
    changeset = Song.changeset(%Song{}, @create_attrs)
    assert changeset.valid?
  end

  test "song suggestor must exist" do
    params = Map.put(@create_attrs, :user_id, Ecto.UUID.generate())
    song = Song.changeset(%Song{}, params)
    {:error, changeset} = Repo.insert(song)

    assert "does not exist" in errors_on(changeset, :user)

  end

  test "artist / title is unique" do
    dj = insert!(:user)
    song = Song.changeset(%Song{}, @create_attrs)
    song_with_user = Ecto.Changeset.put_assoc(song, :user, dj)
    Repo.insert(song_with_user)

    {:error, changeset} = Repo.insert(song_with_user)
    assert "has already been taken" in errors_on(changeset, :title)
  end

  test "bpm must be positive" do
    changeset = Song.changeset(%Song{}, %{bpm: -1})
    assert "must be greater than 0" in errors_on(changeset, :bpm)
  end

  test "title can't be blank" do
    changeset = Song.changeset(%Song{}, %{title: nil})
    assert "can't be blank" in errors_on(changeset, :title)
  end

  test "artist can't be blank" do
    changeset = Song.changeset(%Song{}, %{artist: nil})
    assert "can't be blank" in errors_on(changeset, :artist)
  end

  test "url must be valid" do
    changeset = Song.changeset(%Song{}, %{url: "bullshit"})
    assert "invalid url: :no_scheme" in errors_on(changeset, :url)
  end
end
