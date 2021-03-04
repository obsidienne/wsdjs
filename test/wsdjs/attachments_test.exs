defmodule Brididi.AttachmentsTest do
  use Brididi.DataCase

  alias Brididi.Attachments
  import Brididi.AccountsFixtures

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
