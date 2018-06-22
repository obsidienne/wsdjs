defmodule WsdjsApi.V1.VideoControllerTest do
  use WsdjsWeb.ConnCase
  alias Wsdjs.Accounts

  defp create_user(_) do
    {:ok, user} = Wsdjs.Accounts.create_user(%{"email" => "john@example.com"})

    {:ok, user} =
      Accounts.update_user(user, %{parameter: %{video: true}}, %Accounts.User{admin: true})

    user_token = Phoenix.Token.sign(WsdjsWeb.Endpoint, "user", user.id)

    {:ok, user: user, user_token: user_token}
  end

  defp create_song(%{user: user}) do
    songs = %{
      title: "a",
      artist: "b",
      url: "http://youtu.be/a",
      bpm: 12,
      genre: "rnb",
      user_id: user.id
    }

    {:ok, song} = Wsdjs.Musics.create_song(songs)

    {:ok, song: song}
  end

  defp create_video(%{user: user, song: song}) do
    {:ok, video} =
      %{"url" => "http://youtu.be/video1", "song_id" => song.id, "user_id" => user.id}
      |> Wsdjs.Attachments.create_video()

    {:ok, video: video}
  end

  describe "index/2" do
    setup [:create_user, :create_song]

    test "index/2 responds with all Video's songs", %{
      conn: conn,
      song: song,
      user: user,
      user_token: user_token
    } do
      videos = [
        %{"url" => "http://youtu.be/video1", "song_id" => song.id, "user_id" => user.id},
        %{"url" => "http://youtu.be/video2", "song_id" => song.id, "user_id" => user.id}
      ]

      # create users local to this database connection and test
      [{:ok, video1}, {:ok, video2}] = Enum.map(videos, &Wsdjs.Attachments.create_video(&1))

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> user_token)
        |> get(api_song_video_path(conn, :index, song.id))
        |> json_response(200)

      expected = %{
        "data" => [
          %{
            "event" => nil,
            "id" => video2.id,
            "title" => nil,
            "url" => video2.url,
            "video_id" => "video2"
          },
          %{
            "event" => nil,
            "id" => video1.id,
            "title" => nil,
            "url" => video1.url,
            "video_id" => "video1"
          }
        ]
      }

      assert response == expected
    end
  end

  describe "create/2" do
    setup [:create_user, :create_song]

    test "Creates, and responds with a newly created video if attributes are valid", %{
      conn: conn,
      song: song,
      user_token: user_token
    } do
      response =
        conn
        |> put_req_header("authorization", "Bearer " <> user_token)
        |> post(
          api_song_video_path(conn, :create, song.id),
          video: %{url: "http://www.youtube.com/toto"}
        )
        |> json_response(201)

      expected = %{
        "data" => %{
          "event" => nil,
          "id" => response |> Map.get("data") |> Map.get("id"),
          "title" => nil,
          "url" => "http://www.youtube.com/toto",
          "video_id" => "toto"
        }
      }

      assert response == expected
    end

    test "Returns an error and does not create a video if attributes are invalid", %{
      conn: conn,
      song: song,
      user_token: user_token
    } do
      response =
        conn
        |> put_req_header("authorization", "Bearer " <> user_token)
        |> post(
          api_song_video_path(conn, :create, song.id),
          video: %{url: "dummyvalue"}
        )
        |> json_response(422)

      expected = %{
        "errors" => %{"url" => ["invalid url: :no_scheme"]}
      }

      assert response == expected
    end
  end

  describe "delete videos" do
    setup [:create_user, :create_song, :create_video]

    test "delete/2 and responds with :ok if the video was deleted", %{
      conn: conn,
      song: song,
      video: video,
      user_token: user_token
    } do
      conn
      |> put_req_header("authorization", "Bearer " <> user_token)
      |> delete(api_video_path(conn, :delete, video))
      |> response(204)

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> user_token)
        |> get(api_song_video_path(conn, :index, song))
        |> json_response(200)

      expected = %{"data" => []}
      assert expected == response
    end
  end
end
