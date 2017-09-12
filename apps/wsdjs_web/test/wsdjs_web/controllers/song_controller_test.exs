defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase
  import Wsdjs.Factory


  test "requires user authentication on actions", %{conn: conn} do
    user = insert(:user)
    song = insert(:song, %{user: user})

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

  describe "show" do
    test "instant hit is visible", %{conn: conn} do
      song = insert(:song, %{instant_hit: true})

      Enum.each([
        assign(conn, :current_user, nil),
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ], fn conn ->
        conn = get conn, song_path(conn, :show, song.id)
        assert html_response(conn, 200) =~ "Song - WSDJs"
        assert String.contains?(conn.resp_body, song.title)
      end)
    end

    test "public track is visible", %{conn: conn} do
      song = insert(:song, %{public_track: true})

      Enum.each([
        assign(conn, :current_user, nil),
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ], fn conn ->
        conn = get conn, song_path(conn, :show, song.id)
        assert html_response(conn, 200) =~ "Song - WSDJs"
        assert String.contains?(conn.resp_body, song.title)
      end)
    end

    test "hidden track is hidden", %{conn: conn} do
      song = insert(:song, %{hidden_track: true})

      Enum.each([
        assign(conn, :current_user, song.user),
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user, %{admin: true}))
      ], fn conn ->
        conn = get conn, song_path(conn, :show, song.id)
        assert html_response(conn, 200) =~ "Song - WSDJs"
        assert String.contains?(conn.resp_body, song.title)
      end)

      Enum.each([
        assign(conn, :current_user, nil),
        assign(conn, :current_user, insert(:user, %{profil_dj: true})),
      ], fn conn ->
        conn = get conn, song_path(conn, :show, song.id)
        assert html_response(conn, 302)
        assert conn.halted
      end)
    end

   # test "top 10 song is visible", %{conn: conn, users: users, songs: songs} do
   # end
   # test "top 20 song is visible", %{conn: conn, users: users, songs: songs} do
   # end
   # test "all songs are visible", %{conn: conn, users: users, songs: songs} do
   # end
  end
end
