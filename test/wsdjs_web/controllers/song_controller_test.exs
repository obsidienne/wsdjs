defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase
  alias Wsdjs.Accounts

  defp create_users(_) do
    god = %Accounts.User{admin: true}
    {:ok, suggestor} = Wsdjs.Accounts.create_user(%{"email" => "suggestor@wsdjs.com"})
    {:ok, suggestor} = Accounts.update_user(suggestor, %{"name" => "suggestor"}, god)

    {:ok, user} = Wsdjs.Accounts.create_user(%{"email" => "user@wsdjs.com"})
    {:ok, user} = Accounts.update_user(user, %{"name" => "user"}, god)

    {:ok, dj} = Wsdjs.Accounts.create_user(%{"email" => "dj@wsdjs.com"})
    {:ok, dj} = Accounts.update_user(dj, %{"name" => "dj", "profil_dj" => true}, god)

    {:ok, djvip} = Wsdjs.Accounts.create_user(%{"email" => "djvip@wsdjs.com"})
    {:ok, djvip} = Accounts.update_user(djvip, %{"name" => "djvip", "profil_djvip" => true}, god)

    {:ok, admin} = Wsdjs.Accounts.create_user(%{"name" => "admin", "email" => "admin@wsdjs.com"})

    {:ok, admin} =
      Accounts.update_user(
        admin,
        %{"name" => "admin", "admin" => true},
        god
      )

    {:ok, suggestor: suggestor, user: user, dj: dj, djvip: djvip, admin: admin}
  end

  defp create_songs(%{suggestor: suggestor}) do
    attrs = %{
      artist: "artist",
      url: "http://youtu.be/a",
      bpm: 12,
      genre: "rnb",
      user_id: suggestor.id
    }

    {:ok, song} =
      attrs
      |> Map.put(:title, "song")
      |> Wsdjs.Songs.create_song()

    {:ok, song: song}
  end

  describe "access actions" do
    setup [:create_users, :create_songs]

    test "requires user authentication on actions", %{conn: conn, song: song} do
      Enum.each(
        [
          get(conn, Routes.song_path(conn, :new)),
          get(conn, Routes.live_path(conn, WsdjsWeb.MusicLibrary)),
          get(conn, Routes.song_path(conn, :edit, song.id)),
          put(conn, Routes.song_path(conn, :update, song.id, %{})),
          post(conn, Routes.song_path(conn, :create, %{})),
          delete(conn, Routes.song_path(conn, :delete, song.id))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end
  end
end
