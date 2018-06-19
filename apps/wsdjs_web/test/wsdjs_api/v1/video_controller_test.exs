defmodule WsdjsApi.V1.VideoControllerTest do
  use WsdjsWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  # describe "index" do
  #   test "lists all videos for a song", %{conn: conn} do
  #     song = insert(:song)
  #     conn = get conn, api_song_video_path(conn, :index, song.id)
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  describe "create videos" do
    test "renders videos when data is valid", %{conn: conn} do
      user =
        insert(:user, %{id: "d66d74c0-7c84-4057-8943-91feb397e880", parameter: %{video: true}})

      song = insert(:song, %{user: user})

      user_token = Phoenix.Token.sign(WsdjsWeb.Endpoint, "user", user.id)
      conn = put_req_header(conn, "authorization", "Bearer " <> user_token)

      resp =
        post(
          conn,
          api_song_video_path(conn, :create, song.id),
          video: %{url: "http://www.youtube.com/toto"}
        )

      assert %{"id" => id} = json_response(resp, 201)["data"]

      resp = get(conn, api_song_video_path(conn, :index, song.id))

      assert json_response(resp, 200)["data"] == [
               %{"id" => id, "url" => "http://www.youtube.com/toto"}
             ]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user =
        insert(:user, %{id: "d66d74c0-7c84-4057-8943-91feb397e880", parameter: %{video: true}})

      song = insert(:song, %{user: user})

      user_token = Phoenix.Token.sign(WsdjsWeb.Endpoint, "user", user.id)
      conn = put_req_header(conn, "authorization", "Bearer " <> user_token)

      conn = post(conn, api_song_video_path(conn, :create, song.id), video: %{url: "dummy"})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update videos" do
  #   setup [:create_videos]

  #   test "renders videos when data is valid", %{conn: conn, videos: %Videos{id: id} = videos} do
  #     conn = put conn, videos_path(conn, :update, videos), videos: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, videos_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "url" => "some updated url"}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, videos: videos} do
  #     conn = put conn, videos_path(conn, :update, videos), videos: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete videos" do
  #   setup [:create_videos]

  #   test "deletes chosen videos", %{conn: conn, videos: videos} do
  #     conn = delete conn, videos_path(conn, :delete, videos)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, videos_path(conn, :show, videos)
  #     end
  #   end
  # end

  # defp create_videos(_) do
  #   videos = fixture(:videos)
  #   {:ok, videos: videos}
  # end
end
