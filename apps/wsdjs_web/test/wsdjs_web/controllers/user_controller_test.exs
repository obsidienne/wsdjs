defmodule WsdjsWeb.UserControllerTest do
  use WsdjsWeb.ConnCase
  import WsdjsWeb.Factory

  test "requires user authentication on actions", %{conn: conn} do
    user = insert!(:user)

    Enum.each([
      get(conn, user_path(conn, :index)),
      get(conn, user_path(conn, :edit, user.id)),
      put(conn, user_path(conn, :update, user.id, %{}))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "can edit user", %{conn: conn} do
    
  end
end
