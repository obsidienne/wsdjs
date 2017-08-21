defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase
  import WsdjsWeb.Factory

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
end
