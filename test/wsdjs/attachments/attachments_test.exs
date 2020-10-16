defmodule Wsdjs.AttachmentsTest do
  use Wsdjs.DataCase

  alias Wsdjs.Attachments

  describe "video" do
    alias Wsdjs.Attachments.Videos.Video

    def song_fixture(attrs \\ %{}) do
      user_attrs = %{"email" => "dummy#{System.unique_integer()}@bshit.com"}
      {:ok, %Wsdjs.Accounts.User{} = user} = Wsdjs.Accounts.create_user(user_attrs)

      {:ok, %Wsdjs.Songs.Song{} = song} =
        attrs
        |> Enum.into(%{
          "title" => "my title",
          "artist" => "my artist",
          "genre" => "soul",
          "url" => "http://youtu.be/dummy"
        })
        |> Map.put("user_id", user.id)
        |> Wsdjs.Songs.create_song()

      song
    end

    @valid_attrs %{
      "title" => "my title",
      "event" => "my event",
      "published_at" => "2012-12-12",
      "url" => "http://youtu.be/dummy"
    }
    def video_fixture do
      song = song_fixture()

      {:ok, %Wsdjs.Attachments.Videos.Video{} = video} =
        @valid_attrs
        |> Map.put("user_id", song.user_id)
        |> Map.put("song_id", song.id)
        |> Wsdjs.Attachments.create_video()

      video
    end

    test "list_videos/1 returns all videos for a song" do
      video = video_fixture()
      song = Wsdjs.Songs.get_song!(video.song_id)
      assert Attachments.list_videos(song) == [video] |> Repo.preload(:event)
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
