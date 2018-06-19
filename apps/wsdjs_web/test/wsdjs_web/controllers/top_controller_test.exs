defmodule WsdjsWeb.TopControllerTest do
  use WsdjsWeb.ConnCase

  test "STD users cannot alter a top", %{conn: conn} do
    top = insert(:top)

    Enum.each(
      [
        insert(:user, %{profil_djvip: true}),
        insert(:user, %{profil_dj: true}),
        insert(:user),
        nil
      ],
      fn user ->
        conn = assign(conn, :current_user, user)

        Enum.each(
          [
            get(conn, top_path(conn, :new)),
            put(conn, top_path(conn, :update, top.id, %{"direction" => "next"})),
            put(conn, top_path(conn, :update, top.id, %{"direction" => "previous"})),
            post(conn, top_path(conn, :create), top: %{due_date: Timex.today()}),
            delete(conn, top_path(conn, :delete, top.id))
          ],
          fn conn ->
            assert html_response(conn, 302)
          end
        )
      end
    )
  end

  test "all user can access index", %{conn: conn} do
    Enum.each(
      [
        assign(conn, :current_user, insert(:user, %{admin: true})),
        assign(conn, :current_user, insert(:user, %{profil_djvip: true})),
        assign(conn, :current_user, insert(:user)),
        assign(conn, :current_user, nil)
      ],
      fn conn ->
        conn = get(conn, top_path(conn, :index))
        assert html_response(conn, 200) =~ "List tops - World Swing DJs"
      end
    )
  end
end
