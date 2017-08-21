defmodule WsdjsWeb.TopControllerTest do
  use WsdjsWeb.ConnCase
  import WsdjsWeb.Factory

  test "requires user authentication on actions", %{conn: conn} do
    user = insert!(:user)
    top = insert!(:top, %{user: user})

    Enum.each([
      get(conn, top_path(conn, :new)),
      put(conn, top_path(conn, :update, top.id, %{})),
      post(conn, top_path(conn, :create, %{})),
      delete(conn, top_path(conn, :delete, top.id)),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

end