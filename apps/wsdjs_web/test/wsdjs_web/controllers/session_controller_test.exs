defmodule WsdjsWeb.SessionControllerTest do
  use WsdjsWeb.ConnCase

  test "requires user authentication on actions", %{conn: conn} do
    Enum.each([
      delete(conn, session_path(conn, :delete, Ecto.UUID.generate())),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end
end
