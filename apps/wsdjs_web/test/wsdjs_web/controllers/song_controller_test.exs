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


  describe "index" do
  #  test "instant hits are listed", %{conn: conn, users: users, songs: songs} do
  #  end
  #  test "public tracks are listed", %{conn: conn, users: users, songs: songs} do
  #  end
  #  test "hidden tracks are not listed", %{conn: conn, users: users, songs: songs} do
  #  end
  #  test "top 10 song are listed", %{conn: conn, users: users, songs: songs} do
  #  end
  #  test "top 20 song are listed", %{conn: conn, users: users, songs: songs} do
  #  end
  #  test "all songs are listed", %{conn: conn, users: users, songs: songs} do
  #  end

  end


  describe "show" do
   # test "instant hit is visible", %{conn: conn, users: users, songs: songs} do
   # end
   # test "public track is visible", %{conn: conn, users: users, songs: songs} do
   # end
   # test "hidden track is hidden", %{conn: conn, users: users, songs: songs} do
   # end
   # test "top 10 song is visible", %{conn: conn, users: users, songs: songs} do
   # end
   # test "top 20 song is visible", %{conn: conn, users: users, songs: songs} do
   # end
   # test "all songs are visible", %{conn: conn, users: users, songs: songs} do
   # end
  end
end
