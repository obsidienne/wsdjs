defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase
  import WsdjsWeb.Factory

  setup_all :create_songs

  test "requires user authentication on actions", %{conn: conn} do
    user = insert!(:user)
    song = insert!(:song, %{user: user})

    Enum.each([
      get(conn, song_path(conn, :new)),
      get(conn, song_path(conn, :index)),
      get(conn, song_path(conn, :edit, song.id)),
      put(conn, song_path(conn, :update, song.id, %{})),
      post(conn, song_path(conn, :create, %{})),
      delete(conn, song_path(conn, :delete, song.id)),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  describe "index" do
    test "lists songs for admin", %{conn: conn, users: users, songs: songs} do
      conn = assign(conn, :current_user, users[:admin])
      conn = get conn, song_path(conn, :index)

      assert html_response(conn, 200) =~ songs[:song].title
      assert String.contains?(conn.resp_body, songs[:song_1m_ago].title)
      assert String.contains?(conn.resp_body, songs[:song_2m_ago].title)
      assert String.contains?(conn.resp_body, songs[:song_3m_ago].title)
      assert String.contains?(conn.resp_body, songs[:song_4m_ago].title)
      assert String.contains?(conn.resp_body, songs[:song_27m_ago].title)
      assert String.contains?(conn.resp_body, songs[:song_28m_ago].title)
    end

    test "lists songs for dj", %{conn: conn, users: users, songs: songs} do
      conn = assign(conn, :current_user, users[:dj])
      conn = get conn, song_path(conn, :index)

      assert html_response(conn, 200) =~ songs[:song_3m_ago].title
      assert String.contains?(conn.resp_body, songs[:song_1m_ago].title)
      assert String.contains?(conn.resp_body, songs[:song_2m_ago].title)
      assert String.contains?(conn.resp_body, songs[:song_3m_ago].title)
      assert String.contains?(conn.resp_body, songs[:song_4m_ago].title)
      refute String.contains?(conn.resp_body, songs[:song_27m_ago].title)
      refute String.contains?(conn.resp_body, songs[:song_28m_ago].title)
    end

    test "instant hits are listed", %{conn: conn, users: users, songs: songs} do
    end
    test "public tracks are listed", %{conn: conn, users: users, songs: songs} do
    end
    test "hidden tracks are not listed", %{conn: conn, users: users, songs: songs} do
    end
    test "top 10 song are listed", %{conn: conn, users: users, songs: songs} do
    end
    test "top 20 song are listed", %{conn: conn, users: users, songs: songs} do
    end
    test "all songs are listed", %{conn: conn, users: users, songs: songs} do
    end

  end


  describe "show" do
    test "instant hit is visible", %{conn: conn, users: users, songs: songs} do
    end
    test "public track is visible", %{conn: conn, users: users, songs: songs} do
    end
    test "hidden track is hidden", %{conn: conn, users: users, songs: songs} do
    end
    test "top 10 song is visible", %{conn: conn, users: users, songs: songs} do
    end
    test "top 20 song is visible", %{conn: conn, users: users, songs: songs} do
    end
    test "all songs are visible", %{conn: conn, users: users, songs: songs} do
    end
  end

  defp create_songs(_) do
    users = %{
      user: insert!(:user),
      user2: insert!(:user),
      dj: insert!(:user, profils: ["DJ"]),
      dj2: insert!(:user, profils: ["DJ"]),
      dj_vip: insert!(:user, profils: ["DJ_VIP"]),
      dj_vip2: insert!(:user, profils: ["DJ_VIP"]),
      admin: insert!(:user, %{admin: true})
    }

    songs = %{
      song: insert!(:song, %{user: users[:dj_vip]}),
      song_1m_ago: insert!(:song, %{user: users[:dj_vip], inserted_at: Timex.shift(Timex.now, months: -1)}),
      song_2m_ago: insert!(:song, %{user: users[:dj_vip], inserted_at: Timex.shift(Timex.now, months: -2)}),
      song_3m_ago: insert!(:song, %{user: users[:dj_vip], inserted_at: Timex.shift(Timex.now, months: -3)}),
      song_4m_ago: insert!(:song, %{user: users[:dj_vip], inserted_at: Timex.shift(Timex.now, months: -4)}),
      song_27m_ago: insert!(:song, %{user: users[:dj_vip], inserted_at: Timex.shift(Timex.now, months: -27)}),
      song_28m_ago: insert!(:song, %{user: users[:dj_vip], inserted_at: Timex.shift(Timex.now, months: -28)})
    }

    {:ok, users: users, songs: songs}
  end
end
