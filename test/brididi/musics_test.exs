defmodule Brididi.MusicsTest do
  use Brididi.DataCase
  alias Brididi.Repo

  import Brididi.AccountsFixtures

  describe "songs" do
    alias Brididi.Musics.Song
    alias Brididi.Musics

    @valid_attrs %{
      title: "my title",
      artist: "my artist",
      genre: "soul",
      url: "http://youtu.be/dummy"
    }

    def song_fixture(attrs \\ %{}) do
      {:ok, %Song{} = song} = Musics.create_song(song_params(attrs))

      song
      |> Repo.forget(:comments, :many)
      |> Repo.forget(:opinions, :many)
      |> Repo.forget(:user)
    end

    def song_params(attrs \\ %{}) do
      user = user_fixture()

      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:user_id, user.id)
    end

    test "instant_hits/0 returns all instant hit" do
      song = song_fixture()
      {:ok, %Song{} = song} = Musics.update(song, %{instant_hit: true})
      assert Musics.instant_hits() == [song]
    end

    test "get_song!/1 returns the song with given id" do
      song = song_fixture() |> Repo.preload(:user)
      assert Musics.get_song!(song.id) == song
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
    end

    test "create_song/1 with invalid data returns error changeset" do
      {:ok, dummy_id} = Brididi.HashID.load(999_999_999)
      params = Map.put(@valid_attrs, :user_id, dummy_id)

      assert {:error, changeset} = Musics.create_song(params)
      assert "does not exist" in errors_on(changeset).user

      assert {:error, changeset} = Musics.create_song(song_params(bpm: -1))
      assert "must be greater than 0" in errors_on(changeset).bpm

      assert {:error, changeset} = Musics.create_song(song_params(title: nil))
      assert "can't be blank" in errors_on(changeset).title

      assert {:error, changeset} = Musics.create_song(song_params(artist: nil))
      assert "can't be blank" in errors_on(changeset).artist

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
      public_track: true
    }

    test "update_song/3 with valid data updates the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = Musics.update(song, @update_attrs)
      assert song.title == "update title"
      assert song.artist == "update artist"
      assert song.bpm == 333
      assert song.url == "http://youtube.com/update_url"
      assert song.genre == "rnb"
      assert song.instant_hit == true
      assert song.hidden_track == true
      assert song.public_track == true
    end

    test "update_song/3 with invalid data returns error changeset" do
      song = song_fixture()
      assert {:error, %Ecto.Changeset{}} = Musics.update(song, %{bpm: -1})
    end

    test "delete_song/1 deletes the song" do
      song = song_fixture()
      assert {:ok, %Song{} = song} = Musics.delete(song)
      assert_raise Ecto.NoResultsError, fn -> Musics.get_song!(song.id) end
    end

    test "change_song/1 returns a song changeset" do
      song = song_fixture()
      assert %Ecto.Changeset{} = Musics.change(song)
    end
  end

  describe "video" do
    alias Brididi.Attachments.Video

    def song_fixture(attrs \\ %{}) do
      user = user_fixture()

      {:ok, %Brididi.Musics.Song{} = song} =
        attrs
        |> Enum.into(%{
          "title" => "my title",
          "artist" => "my artist",
          "genre" => "soul",
          "url" => "http://youtu.be/dummy"
        })
        |> Map.put("user_id", user.id)
        |> Brididi.Musics.create_song()

      song
    end

    @valid_attrs %{
      "title" => "my title",
      "published_at" => "2012-12-12",
      "url" => "http://youtu.be/dummy"
    }
    def video_fixture do
      song = song_fixture()

      {:ok, %Brididi.Attachments.Video{} = video} =
        @valid_attrs
        |> Map.put("user_id", song.user_id)
        |> Map.put("song_id", song.id)
        |> Brididi.Attachments.create_video()

      video
    end

    test "list_videos/1 returns all videos for a song" do
      video = video_fixture()
      song = Brididi.Musics.get_song!(video.song_id)
      assert Attachments.list_videos(song) == [video]
    end

    test "get_video!/1 returns the videos with given id" do
      video = video_fixture()
      assert Attachments.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a videos" do
      song = song_fixture()

      params = %{
        "url" => "http://youtu.be/dummy",
        "user_id" => song.user_id,
        "song_id" => song.id
      }

      assert {:ok, %Video{} = video} = Attachments.create_video(params)
      assert video.url == "http://youtu.be/dummy"
    end

    test "create_video/1 with invalid data returns error changeset" do
      song = song_fixture()
      params = %{"url" => "false url", "user_id" => song.user_id, "song_id" => song.id}
      assert {:error, %Ecto.Changeset{}} = Attachments.create_video(params)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Attachments.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Attachments.get_video!(video.id) end
    end

    test "change_videos/1 returns a videos changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Attachments.change_video(video)
    end
  end

end
