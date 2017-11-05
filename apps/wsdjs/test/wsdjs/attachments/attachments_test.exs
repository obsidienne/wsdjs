defmodule Wsdjs.AttachmentsTest do
  use Wsdjs.DataCase
  import Wsdjs.Factory

  alias Wsdjs.Attachments

  describe "video" do
    alias Wsdjs.Attachments.Video

    test "list_videos/1 returns all videos for a song" do
      song = insert(:song)
      videos = insert_list(3, :video, song: song) |> Enum.sort()
      assert Attachments.list_videos(song) |> Repo.preload([:user, song: :user]) |> Enum.sort() == videos
    end

    test "get_video!/1 returns the videos with given id" do
      video = insert(:video)
      assert Attachments.get_video!(video.id) |> Repo.preload([:user, song: :user]) == video
    end

    test "create_video/1 with valid data creates a videos" do
      song = insert(:song)
      params = %{url: "http://youtu.be/dummy", user_id: song.user.id, song_id: song.id}
      assert {:ok, %Video{} = video} = Attachments.create_video(params)
      assert video.url == "http://youtu.be/dummy"
    end

    test "create_video/1 with invalid data returns error changeset" do
      song = insert(:song)
      params = %{url: "false url", user_id: song.user.id, song_id: song.id}
      assert {:error, %Ecto.Changeset{}} = Attachments.create_video(params)
    end

    test "delete_video/1 deletes the video" do
      video = insert(:video)
      assert {:ok, %Video{}} = Attachments.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Attachments.get_video!(video.id) end
    end

    test "change_videos/1 returns a videos changeset" do
      video = insert(:video)
      assert %Ecto.Changeset{} = Attachments.change_video(video)
    end
  end
end
