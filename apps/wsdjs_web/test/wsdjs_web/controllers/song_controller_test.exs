defmodule WsdjsWeb.SongControllerTest do
  use WsdjsWeb.ConnCase

  alias Wsdjs.Musics

  @create_attrs %{artist: "some artist", title: "some title"}
#  @update_attrs %{artist: "some updated artist", title: "some updated title"}
#  @invalid_attrs %{artist: nil, title: nil}

  def fixture(:song) do
    {:ok, song} = Musics.create_song(@create_attrs)
    song
  end

#  test "lists all entries on index", %{conn: conn} do
#    conn = get conn, song_path(conn, :index)
#    assert html_response(conn, 200) =~ "Listing Songs"
#  end

#  test "renders form for new songs", %{conn: conn} do
#    conn = get conn, song_path(conn, :new)
#    assert html_response(conn, 200) =~ "New Song"
#  end

#  test "creates song and redirects to show when data is valid", %{conn: conn} do
#    conn = post conn, song_path(conn, :create), song: @create_attrs
#
#    assert %{id: id} = redirected_params(conn)
#    assert redirected_to(conn) == song_path(conn, :show, id)
#
#    conn = get conn, song_path(conn, :show, id)
#    assert html_response(conn, 200) =~ "Show Song"
#  end

#  test "does not create song and renders errors when data is invalid", %{conn: conn} do
#    conn = post conn, song_path(conn, :create), song: @invalid_attrs
#    assert html_response(conn, 200) =~ "New Song"
#  end

#  test "renders form for editing chosen song", %{conn: conn} do
#    song = fixture(:song)
#    conn = get conn, song_path(conn, :edit, song)
#    assert html_response(conn, 200) =~ "Edit Song"
#  end

#  test "updates chosen song and redirects when data is valid", %{conn: conn} do
#    song = fixture(:song)
#    conn = put conn, song_path(conn, :update, song), song: @update_attrs
#    assert redirected_to(conn) == song_path(conn, :show, song)
#
#    conn = get conn, song_path(conn, :show, song)
#    assert html_response(conn, 200) =~ "some updated artist"
#  end

#  test "does not update chosen song and renders errors when data is invalid", %{conn: conn} do
#    song = fixture(:song)
#    conn = put conn, song_path(conn, :update, song), song: @invalid_attrs
#    assert html_response(conn, 200) =~ "Edit Song"
#  end

#  test "deletes chosen song", %{conn: conn} do
#    song = fixture(:song)
#    conn = delete conn, song_path(conn, :delete, song)
#    assert redirected_to(conn) == song_path(conn, :index)
#    assert_error_sent 404, fn ->
#      get conn, song_path(conn, :show, song)
#    end
#  end
end
