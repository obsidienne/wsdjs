defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase
  alias Wsdjs.Accounts

  import Wsdjs.AccountsFixtures

  defp create_users(_) do
    god = %Accounts.User{admin: true}
    suggestor = user_fixture()
    {:ok, suggestor} = Accounts.update_user(suggestor, %{"name" => "suggestor"}, god)

    user = user_fixture()
    {:ok, user} = Accounts.update_user(user, %{"name" => "user"}, god)

    dj = user_fixture()
    {:ok, dj} = Accounts.update_user(dj, %{"name" => "dj", "profil_dj" => true}, god)

    djvip = user_fixture()
    {:ok, djvip} = Accounts.update_user(djvip, %{"name" => "djvip", "profil_djvip" => true}, god)

    admin = user_fixture()

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
      |> Wsdjs.Musics.create_song()

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
