defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase
  import WsdjsWeb.Factory

  alias Wsdjs.Musics

  test "requires user authentication on actions", %{conn: conn} do
    user = insert!(:user)
    song = insert!(:song, %{user: user})

    Enum.each([
      get(conn, song_path(conn, :new)),
      get(conn, song_path(conn, :index)),
  #    get(conn, song_path(conn, :edit, song.id)),
  #    put(conn, song_path(conn, :update, song.id, %{})),
      post(conn, song_path(conn, :create, %{})),
      delete(conn, song_path(conn, :delete, song.id)),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end


#  describe "create song" do
#    test "redirects to show when data is valid", %{conn: conn} do
#      conn = post conn, song_path(conn, :create), song: @create_attrs

#      assert %{id: id} = redirected_params(conn)
#      assert redirected_to(conn) == song_path(conn, :show, id)

#      conn = get conn, song_path(conn, :show, id)
#      assert html_response(conn, 200) =~ "Show Song"
#    end

#    test "renders errors when data is invalid", %{conn: conn} do
#      conn = post conn, song_path(conn, :create), song: @invalid_attrs
#      assert html_response(conn, 200) =~ "New Song"
#    end
#  end

#  describe "edit song" do
#    setup [:create_song]

#    test "renders form for editing chosen song", %{conn: conn, song: song} do
#      conn = get conn, song_path(conn, :edit, song)
#      assert html_response(conn, 200) =~ "Edit Song"
#    end
#  end

#  describe "update song" do
#    setup [:create_song]

#    test "redirects when data is valid", %{conn: conn, song: song} do
#      conn = put conn, song_path(conn, :update, song), song: @update_attrs
#      assert redirected_to(conn) == song_path(conn, :show, song)

#      conn = get conn, song_path(conn, :show, song)
#      assert html_response(conn, 200) =~ "some updated artist"
#    end

#    test "renders errors when data is invalid", %{conn: conn, song: song} do
#      conn = put conn, song_path(conn, :update, song), song: @invalid_attrs
#      assert html_response(conn, 200) =~ "Edit Song"
#    end
#  end

#  describe "delete song" do
#    setup [:create_song]

#    test "deletes chosen song", %{conn: conn, song: song} do
#      conn = delete conn, song_path(conn, :delete, song)
#      assert redirected_to(conn) == song_path(conn, :index)
#      assert_error_sent 404, fn ->
#        get conn, song_path(conn, :show, song)
#      end
#    end
#  end

#  defp create_song(_) do
#    song = fixture(:song)
#    {:ok, song: song}
#  end
end
