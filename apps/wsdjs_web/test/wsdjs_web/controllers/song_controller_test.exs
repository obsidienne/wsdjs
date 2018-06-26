defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase
  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

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
        %{"name" => "admin", "admin" => true, "parameter" => %{email_contact: true}},
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

    {:ok, instant_hit} =
      attrs
      |> Map.put(:title, "instant hit")
      |> Wsdjs.Musics.create_song!()
      |> Wsdjs.Musics.update_song(%{instant_hit: true}, %User{admin: true})

    {:ok, public_track} =
      attrs
      |> Map.put(:title, "public track")
      |> Wsdjs.Musics.create_song!()
      |> Wsdjs.Musics.update_song(%{public_track: true}, %User{admin: true})

    {:ok, hidden_track} =
      attrs
      |> Map.put(:title, "hidden track")
      |> Wsdjs.Musics.create_song!()
      |> Wsdjs.Musics.update_song(%{hidden_track: true}, %User{admin: true})

    {:ok,
     song: song, instant_hit: instant_hit, public_track: public_track, hidden_track: hidden_track}
  end

  describe "access" do
    setup [:create_users, :create_songs]

    test "requires user authentication on actions", %{conn: conn, song: song} do
      Enum.each(
        [
          get(conn, song_path(conn, :new)),
          get(conn, song_path(conn, :index)),
          get(conn, song_path(conn, :edit, song.id)),
          put(conn, song_path(conn, :update, song.id, %{})),
          post(conn, song_path(conn, :create, %{})),
          delete(conn, song_path(conn, :delete, song.id))
        ],
        fn conn ->
          assert html_response(conn, 302)
          assert conn.halted
        end
      )
    end

    test "instant hit is visible", %{
      conn: conn,
      instant_hit: instant_hit,
      suggestor: suggestor,
      dj: dj,
      djvip: djvip,
      admin: admin
    } do
      Enum.each(
        [
          assign(conn, :current_user, nil),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, djvip),
          assign(conn, :current_user, admin),
          assign(conn, :current_user, suggestor)
        ],
        fn conn ->
          conn = get(conn, song_path(conn, :show, instant_hit))
          assert html_response(conn, 200) =~ "Song - World Swing DJs"
          assert String.contains?(conn.resp_body, instant_hit.title)
        end
      )
    end

    test "public track is visible", %{
      conn: conn,
      public_track: public_track,
      suggestor: suggestor,
      dj: dj,
      djvip: djvip,
      admin: admin
    } do
      Enum.each(
        [
          assign(conn, :current_user, nil),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, djvip),
          assign(conn, :current_user, admin),
          assign(conn, :current_user, suggestor)
        ],
        fn conn ->
          conn = get(conn, song_path(conn, :show, public_track))
          assert html_response(conn, 200) =~ "Song - World Swing DJs"
          assert String.contains?(conn.resp_body, public_track.title)
        end
      )
    end

    test "hidden track is hidden", %{
      conn: conn,
      hidden_track: hidden_track,
      suggestor: suggestor,
      user: user,
      dj: dj,
      djvip: djvip,
      admin: admin
    } do
      Enum.each(
        [
          assign(conn, :current_user, djvip),
          assign(conn, :current_user, admin),
          assign(conn, :current_user, suggestor)
        ],
        fn conn ->
          conn = get(conn, song_path(conn, :show, hidden_track))
          assert html_response(conn, 200) =~ "Song - World Swing DJs"
          assert String.contains?(conn.resp_body, hidden_track.title)
        end
      )

      Enum.each(
        [
          assign(conn, :current_user, nil),
          assign(conn, :current_user, user),
          assign(conn, :current_user, dj)
        ],
        fn conn ->
          conn = get(conn, song_path(conn, :show, hidden_track))
          assert html_response(conn, 302)
        end
      )
    end

    test "show my song", %{
      conn: conn,
      song: song,
      public_track: public_track,
      instant_hit: instant_hit,
      hidden_track: hidden_track,
      suggestor: suggestor
    } do
      conn = assign(conn, :current_user, suggestor)

      Enum.each(
        [song, public_track, instant_hit, hidden_track],
        fn song ->
          conn = get(conn, song_path(conn, :show, song))
          assert html_response(conn, 200) =~ "Song - World Swing DJs"
          assert String.contains?(conn.resp_body, song.title)
        end
      )
    end
  end

  # only published top set the position value in ranks
  #  test "show song TOP current month", %{conn: conn} do
  # dt = Timex.beginning_of_month(Timex.today())
  # top = insert(:top, %{due_date: dt, status: "published"})
  # rank1 = insert(:rank, position: 1, top: top)
  # rank10 = insert(:rank, position: 10, top: top)
  # rank11 = insert(:rank, position: 11, top: top)

  # Enum.each(
  #   [
  #     assign(conn, :current_user, insert(:user, %{profil_dj: true})),
  #     assign(conn, :current_user, insert(:user)),
  #     assign(conn, :current_user, nil)
  #   ],
  #   fn conn ->
  #     Enum.each([rank1, rank10, rank11], fn rank ->
  #       conn = get(conn, song_path(conn, :show, rank.song.id))
  #       assert html_response(conn, 302)
  #     end)
  #   end
  # )

  #   Enum.each(
  #     [
  #       assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
  #       assign(conn, :current_user, insert(:user, %{admin: true}))
  #     ],
  #     fn conn ->
  #       Enum.each([rank1, rank10, rank11], fn rank ->
  #         conn = get(conn, song_path(conn, :show, rank.song.id))
  #         assert html_response(conn, 200) =~ "Song - World Swing DJs"
  #         assert String.contains?(conn.resp_body, rank.song.title)
  #       end)
  #     end
  #   )
  # end

  # test "show song TOP current month -2", %{conn: conn} do
  #   dt =
  #     Timex.today()
  #     |> Timex.beginning_of_month()
  #     |> Timex.shift(months: -2)

  #   top = insert(:top, %{due_date: dt, status: "published"})
  #   rank1 = insert(:rank, position: 1, top: top)
  #   rank10 = insert(:rank, position: 10, top: top)
  #   rank11 = insert(:rank, position: 11, top: top)

  #   Enum.each(
  #     [
  #       assign(conn, :current_user, insert(:user, %{profil_dj: true})),
  #       assign(conn, :current_user, insert(:user)),
  #       assign(conn, :current_user, nil)
  #     ],
  #     fn conn ->
  #       Enum.each([rank1, rank10, rank11], fn rank ->
  #         conn = get(conn, song_path(conn, :show, rank.song.id))
  #         assert html_response(conn, 302)
  #       end)
  #     end
  #   )

  #   Enum.each(
  #     [
  #       assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
  #       assign(conn, :current_user, insert(:user, %{admin: true}))
  #     ],
  #     fn conn ->
  #       Enum.each([rank1, rank10, rank11], fn rank ->
  #         conn = get(conn, song_path(conn, :show, rank.song.id))
  #         assert html_response(conn, 200) =~ "Song - World Swing DJs"
  #         assert String.contains?(conn.resp_body, rank.song.title)
  #       end)
  #     end
  #   )
  # end

  # test "show song TOP current month -3", %{conn: conn} do
  # dt =
  #   Timex.today()
  #   |> Timex.beginning_of_month()
  #   |> Timex.shift(months: -3)

  # top = insert(:top, %{due_date: dt, status: "published"})
  # rank1 = insert(:rank, position: 1, top: top)
  # rank10 = insert(:rank, position: 10, top: top)
  # rank11 = insert(:rank, position: 11, top: top)

  # Enum.each(
  #   [
  #     assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
  #     assign(conn, :current_user, insert(:user, %{admin: true}))
  #   ],
  #   fn conn ->
  #     Enum.each([rank11], fn rank ->
  #       conn = get(conn, song_path(conn, :show, rank.song.id))
  #       assert html_response(conn, 200) =~ "Song - World Swing DJs"
  #       assert String.contains?(conn.resp_body, rank.song.title)
  #     end)
  #   end
  # )

  # Enum.each(
  #   [
  #     assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
  #     assign(conn, :current_user, insert(:user, %{admin: true})),
  #     assign(conn, :current_user, insert(:user, %{profil_dj: true})),
  #     assign(conn, :current_user, insert(:user)),
  #     assign(conn, :current_user, nil)
  #   ],
  #   fn conn ->
  #     Enum.each([rank1, rank10], fn rank ->
  #       conn = get(conn, song_path(conn, :show, rank.song.id))
  #       assert html_response(conn, 200) =~ "Song - World Swing DJs"
  #       assert String.contains?(conn.resp_body, rank.song.title)
  #     end)
  #   end
  # )
end

# test "show song TOP current month -6", %{conn: conn} do
#   dt =
#     Timex.today()
#     |> Timex.beginning_of_month()
#     |> Timex.shift(months: -6)

#   top = insert(:top, %{due_date: dt, status: "published"})
#   rank1 = insert(:rank, position: 1, top: top)
#   rank10 = insert(:rank, position: 10, top: top)
#   rank11 = insert(:rank, position: 11, top: top)

#   Enum.each(
#     [
#       assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
#       assign(conn, :current_user, insert(:user, %{admin: true}))
#     ],
#     fn conn ->
#       Enum.each([rank11], fn rank ->
#         conn = get(conn, song_path(conn, :show, rank.song.id))
#         assert html_response(conn, 200) =~ "Song - World Swing DJs"
#         assert String.contains?(conn.resp_body, rank.song.title)
#       end)
#     end
#   )

#   Enum.each(
#     [
#       assign(conn, :current_user, insert(:user, %{admin: true})),
#       assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
#       assign(conn, :current_user, insert(:user, %{profil_dj: true})),
#       assign(conn, :current_user, insert(:user)),
#       assign(conn, :current_user, nil)
#     ],
#     fn conn ->
#       Enum.each([rank1, rank10], fn rank ->
#         conn = get(conn, song_path(conn, :show, rank.song.id))
#         assert html_response(conn, 200) =~ "Song - World Swing DJs"
#         assert String.contains?(conn.resp_body, rank.song.title)
#       end)
#     end
#   )
# end

# test "show song TOP current month -27", %{conn: conn} do
#   dt =
#     Timex.today()
#     |> Timex.beginning_of_month()
#     |> Timex.shift(months: -27)

#   top = insert(:top, %{due_date: dt, status: "published"})
#   rank1 = insert(:rank, position: 1, top: top)
#   rank10 = insert(:rank, position: 10, top: top)
#   rank11 = insert(:rank, position: 11, top: top)

#   Enum.each(
#     [
#       assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
#       assign(conn, :current_user, insert(:user, %{admin: true}))
#     ],
#     fn conn ->
#       Enum.each([rank11], fn rank ->
#         conn = get(conn, song_path(conn, :show, rank.song.id))
#         assert html_response(conn, 200) =~ "Song - World Swing DJs"
#         assert String.contains?(conn.resp_body, rank.song.title)
#       end)
#     end
#   )

#   Enum.each(
#     [
#       assign(conn, :current_user, insert(:user, %{admin: true})),
#       assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
#       assign(conn, :current_user, insert(:user, %{profil_dj: true}))
#     ],
#     fn conn ->
#       Enum.each([rank1, rank10], fn rank ->
#         conn = get(conn, song_path(conn, :show, rank.song.id))
#         assert html_response(conn, 200) =~ "Song - World Swing DJs"
#         assert String.contains?(conn.resp_body, rank.song.title)
#       end)
#     end
#   )

#   Enum.each(
#     [
#       assign(conn, :current_user, insert(:user)),
#       assign(conn, :current_user, nil)
#     ],
#     fn conn ->
#       Enum.each([rank1, rank10, rank11], fn rank ->
#         conn = get(conn, song_path(conn, :show, rank.song.id))
#         assert html_response(conn, 302)
#       end)
#     end
#   )
# end

# test "show song TOP current month -28", %{conn: conn} do
#   dt =
#     Timex.today()
#     |> Timex.beginning_of_month()
#     |> Timex.shift(months: -28)

#   top = insert(:top, %{due_date: dt, status: "published"})
#   rank1 = insert(:rank, position: 1, top: top)
#   rank10 = insert(:rank, position: 10, top: top)
#   rank11 = insert(:rank, position: 11, top: top)

#   Enum.each(
#     [
#       assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
#       assign(conn, :current_user, insert(:user, %{admin: true}))
#     ],
#     fn conn ->
#       Enum.each([rank11], fn rank ->
#         conn = get(conn, song_path(conn, :show, rank.song.id))
#         assert html_response(conn, 200) =~ "Song - World Swing DJs"
#         assert String.contains?(conn.resp_body, rank.song.title)
#       end)
#     end
#   )

#   Enum.each(
#     [
#       assign(conn, :current_user, insert(:user, %{profil_dj: true})),
#       assign(conn, :current_user, insert(:user)),
#       assign(conn, :current_user, nil)
#     ],
#     fn conn ->
#       Enum.each([rank1, rank10, rank11], fn rank ->
#         conn = get(conn, song_path(conn, :show, rank.song.id))
#         assert html_response(conn, 302)
#       end)
#     end
#   )
# end
# end
