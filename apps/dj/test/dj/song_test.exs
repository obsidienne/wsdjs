defmodule Dj.SongTest do
  use Dj.Case, async: true

  @valid_attrs %{title: "song title", artist: "the artist", url: "http://song_url.com", genre: "pop"}

  defp errors_on(model, params) do
    model.__struct__.changeset(model, params).errors
  end

  setup _tags do
    # need a better way
    account = Wcs.Account.build(%{email: "test@test.com"})
    dj = Repo.insert!(account)
    {:ok, %{account: dj}}
  end

  test "changeset with minimal valid attributes" do
    changeset = Song.changeset(%Song{}, @valid_attrs)
    assert changeset.valid?
  end

  test "song suggestor must exist" do
    params = Map.put(@valid_attrs, :account_id, Ecto.UUID.generate())
    song = Song.changeset(%Song{}, params)
    assert {:error, %{errors: [account: {"does not exist", _}]}} = Repo.insert(song)
  end

  test "artist / title is unique", %{account: dj} do
    song = Song.changeset(%Song{}, @valid_attrs)
    song_with_account = Ecto.Changeset.put_assoc(song, :account, dj)
    Repo.insert(song_with_account)

    assert {:error, %{errors: [title: {"has already been taken", []}]}} = Dj.Repo.insert(song_with_account)
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
