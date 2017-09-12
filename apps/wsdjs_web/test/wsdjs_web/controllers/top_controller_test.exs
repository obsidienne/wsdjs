defmodule WsdjsWeb.TopControllerTest do
  use WsdjsWeb.ConnCase
  import Wsdjs.Factory

  test "requires user authentication on actions", %{conn: conn} do
    user = insert(:user)
    top = insert(:top, %{user: user})

    Enum.each([
      get(conn, top_path(conn, :new)),
      put(conn, top_path(conn, :update, top.id, %{})),
      post(conn, top_path(conn, :create, %{})),
      delete(conn, top_path(conn, :delete, top.id))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "all user can access index", %{conn: conn} do
    Enum.each([
      assign(conn, :current_user, insert(:user, %{admin: true})),
      assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
      assign(conn, :current_user, insert(:user, %{profil_dj: true})),
      assign(conn, :current_user, nil)
    ], fn conn ->
      conn = get conn, top_path(conn, :index)
      assert html_response(conn, 200) =~ "Tops - WSDJs"
    end)
  end
end
