defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase
  import Wsdjs.Factory

  test "requires user authentication on actions", %{conn: conn} do
    user = insert(:user)
    song = insert(:song, %{user: user})

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

  test "instant hit is visible", %{conn: conn} do
    song = insert(:song, %{instant_hit: true})

    Enum.each(
      [
        assign(conn, :current_user, nil),
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ],
      fn conn ->
        conn = get(conn, song_path(conn, :show, song.id))
        assert html_response(conn, 200) =~ "Song - WSDJs"
        assert String.contains?(conn.resp_body, song.title)
      end
    )
  end

  test "public track is visible", %{conn: conn} do
    song = insert(:song, %{public_track: true})

    Enum.each(
      [
        assign(conn, :current_user, nil),
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ],
      fn conn ->
        conn = get(conn, song_path(conn, :show, song.id))
        assert html_response(conn, 200) =~ "Song - WSDJs"
        assert String.contains?(conn.resp_body, song.title)
      end
    )
  end

  test "hidden track is hidden", %{conn: conn} do
    song = insert(:song, %{hidden_track: true})

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true})),
        assign(conn, :current_user, song.user)
      ],
      fn conn ->
        conn = get(conn, song_path(conn, :show, song.id))
        assert html_response(conn, 200) =~ "Song - WSDJs"
        assert String.contains?(conn.resp_body, song.title)
      end
    )

    Enum.each(
      [
        assign(conn, :current_user, nil),
        assign(conn, :current_user, insert(:user)),
        assign(conn, :current_user, insert(:user, %{profil_dj: true}))
      ],
      fn conn ->
        conn = get(conn, song_path(conn, :show, song.id))
        assert html_response(conn, 302)
      end
    )
  end

  test "show my song", %{conn: conn} do
    user = insert(:user, %{profil_djvip: true})
    conn = assign(conn, :current_user, user)

    Enum.each(
      [
        insert(:song, %{user: user}),
        insert(:song, %{user: user, public_track: true}),
        insert(:song, %{user: user, instant_hit: true}),
        insert(:song, %{user: user, hidden_track: true})
      ],
      fn song ->
        conn = get(conn, song_path(conn, :show, song.id))
        assert html_response(conn, 200) =~ "Song - WSDJs"
        assert String.contains?(conn.resp_body, song.title)
      end
    )
  end

  # only published top set the position value in ranks
  test "show song TOP current month", %{conn: conn} do
    dt = Timex.beginning_of_month(Timex.today())
    top = insert(:top, %{due_date: dt, status: "published"})
    rank1 = insert(:rank, position: 1, top: top)
    rank10 = insert(:rank, position: 10, top: top)
    rank11 = insert(:rank, position: 11, top: top)

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user)),
        assign(conn, :current_user, nil)
      ],
      fn conn ->
        Enum.each([rank1, rank10, rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 302)
        end)
      end
    )

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ],
      fn conn ->
        Enum.each([rank1, rank10, rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )
  end

  test "show song TOP current month -2", %{conn: conn} do
    dt =
      Timex.today()
      |> Timex.beginning_of_month()
      |> Timex.shift(months: -2)

    top = insert(:top, %{due_date: dt, status: "published"})
    rank1 = insert(:rank, position: 1, top: top)
    rank10 = insert(:rank, position: 10, top: top)
    rank11 = insert(:rank, position: 11, top: top)

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user)),
        assign(conn, :current_user, nil)
      ],
      fn conn ->
        Enum.each([rank1, rank10, rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 302)
        end)
      end
    )

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ],
      fn conn ->
        Enum.each([rank1, rank10, rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )
  end

  test "show song TOP current month -3", %{conn: conn} do
    dt =
      Timex.today()
      |> Timex.beginning_of_month()
      |> Timex.shift(months: -3)

    top = insert(:top, %{due_date: dt, status: "published"})
    rank1 = insert(:rank, position: 1, top: top)
    rank10 = insert(:rank, position: 10, top: top)
    rank11 = insert(:rank, position: 11, top: top)

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ],
      fn conn ->
        Enum.each([rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true})),
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user)),
        assign(conn, :current_user, nil)
      ],
      fn conn ->
        Enum.each([rank1, rank10], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )
  end

  test "show song TOP current month -6", %{conn: conn} do
    dt =
      Timex.today()
      |> Timex.beginning_of_month()
      |> Timex.shift(months: -6)

    top = insert(:top, %{due_date: dt, status: "published"})
    rank1 = insert(:rank, position: 1, top: top)
    rank10 = insert(:rank, position: 10, top: top)
    rank11 = insert(:rank, position: 11, top: top)

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ],
      fn conn ->
        Enum.each([rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{admin: true})),
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user)),
        assign(conn, :current_user, nil)
      ],
      fn conn ->
        Enum.each([rank1, rank10], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )
  end

  test "show song TOP current month -27", %{conn: conn} do
    dt =
      Timex.today()
      |> Timex.beginning_of_month()
      |> Timex.shift(months: -27)

    top = insert(:top, %{due_date: dt, status: "published"})
    rank1 = insert(:rank, position: 1, top: top)
    rank10 = insert(:rank, position: 10, top: top)
    rank11 = insert(:rank, position: 11, top: top)

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ],
      fn conn ->
        Enum.each([rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{admin: true})),
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{profil_dj: true}))
      ],
      fn conn ->
        Enum.each([rank1, rank10], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )

    Enum.each(
      [
        assign(conn, :current_user, insert(:user)),
        assign(conn, :current_user, nil)
      ],
      fn conn ->
        Enum.each([rank1, rank10, rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 302)
        end)
      end
    )
  end

  test "show song TOP current month -28", %{conn: conn} do
    dt =
      Timex.today()
      |> Timex.beginning_of_month()
      |> Timex.shift(months: -28)

    top = insert(:top, %{due_date: dt, status: "published"})
    rank1 = insert(:rank, position: 1, top: top)
    rank10 = insert(:rank, position: 10, top: top)
    rank11 = insert(:rank, position: 11, top: top)

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ],
      fn conn ->
        Enum.each([rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 200) =~ "Song - WSDJs"
          assert String.contains?(conn.resp_body, rank.song.title)
        end)
      end
    )

    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user)),
        assign(conn, :current_user, nil)
      ],
      fn conn ->
        Enum.each([rank1, rank10, rank11], fn rank ->
          conn = get(conn, song_path(conn, :show, rank.song.id))
          assert html_response(conn, 302)
        end)
      end
    )
  end
end
