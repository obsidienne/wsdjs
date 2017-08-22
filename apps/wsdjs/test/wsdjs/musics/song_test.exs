defmodule Wsdjs.SongTest do
  use Wsdjs.DataCase, async: true
  import Wsdjs.Factory

  alias Wsdjs.Musics.Song
  alias Wsdjs.Charts.Rank
  
  @create_attrs %{title: "song title", artist: "the artist", url: "http://song_url.com", genre: "pop"}

  describe  "changeset" do
    test "changeset with minimal valid attributes" do
      changeset = Song.changeset(%Song{}, @create_attrs)
      assert changeset.valid?
    end

    test "song suggestor must exist" do
      params = Map.put(@create_attrs, :user_id, Ecto.UUID.generate())
      song = Song.changeset(%Song{}, params)
      {:error, changeset} = Repo.insert(song)

      assert "does not exist" in errors_on(changeset).user
    end

    test "artist / title is unique" do
      dj = insert!(:user)
      song = Song.changeset(%Song{}, @create_attrs)
      song_with_user = Ecto.Changeset.put_assoc(song, :user, dj)
      Repo.insert(song_with_user)

      {:error, changeset} = Repo.insert(song_with_user)
      assert "has already been taken" in errors_on(changeset).title
    end

    test "bpm must be positive" do
      changeset = Song.changeset(%Song{}, %{bpm: -1})
      assert "must be greater than 0" in errors_on(changeset).bpm
    end

    test "title can't be blank" do
      changeset = Song.changeset(%Song{}, %{title: nil})
      assert "can't be blank" in errors_on(changeset).title
    end

    test "artist can't be blank" do
      changeset = Song.changeset(%Song{}, %{artist: nil})
      assert "can't be blank" in errors_on(changeset).artist
    end

    test "url must be valid" do
      changeset = Song.changeset(%Song{}, %{url: "bullshit"})
      assert "invalid url: :no_scheme" in errors_on(changeset).url
    end
  end

  # Top 10  # Instant hit: always visible
  # public track: always visible



  describe "Song.scoped(nil)" do
    # instant hits are visible
    test "instant hit" do
      user = insert!(:user)
      song = insert!(:song, %{instant_hit: true, user_id: user.id})

      scoped = Song.scoped(nil) |> Repo.all()
      assert scoped == [song]
    end

    # public tracks are visible
    test "public track" do
      user = insert!(:user)
      song = insert!(:song, %{public_track: true, user_id: user.id})

      scoped = Song.scoped(nil) |> Repo.all()
      assert scoped == [song]
    end

    # hidden tracks are invisible
    test "hidden track" do
      user = insert!(:user)
      song = insert!(:song, %{hidden_track: true, user_id: user.id})

      scoped = Song.scoped(nil) |> Repo.all()
      assert Enum.count(scoped) == 0
    end

    # top, first 10 songs are visible if top in [m-3, m-6]
    test "top 10" do
      top = create_filled_top(0)
      
    end
  end

  defp create_top(status, shift) do
    admin = insert!(:user, %{admin: true})

    dt = Timex.today
    |> Timex.beginning_of_month()
    |> Timex.shift(months: shift)
    insert!(:top, %{user_id: admin.id, status: status, due_date: dt})
  end

  defp create_filled_top(shift) do
    admin = insert!(:user, %{admin: true})
    user = insert!(:user, %{profils: ["DJ_VIP"]})

    dt = Timex.today
    |> Timex.beginning_of_month()
    |> Timex.shift(months: shift)

    top = insert!(:top, %{user_id: admin.id, status: "published", due_date: dt})

    Enum.each(1..21, fn pos ->
      song = insert!(:song, %{user_id: user.id})
      Repo.insert!(%Rank{position: pos, song: song, top: top})
    end)
  end
end
