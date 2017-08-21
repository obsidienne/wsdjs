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


  describe "index" do
    setup [:create_empty_tops]

    test "tops for admin", %{conn: conn, tops: tops} do
    end

    test "tops for DJ VIP", %{conn: conn, tops: tops} do
    end

    test "tops for DJ", %{conn: conn, tops: tops} do
    end

    test "tops for unauthenticated", %{conn: conn, tops: tops} do
      conn = get conn, top_path(conn, :index)
      assert html_response(conn, 200) =~ "Tops - WSDJs"
    end
  end

  defp create_empty_tops(_) do
    month_start = Timex.beginning_of_month(Timex.today)
    admin = insert!(:user, %{admin: true})

    tops = %{
      top: insert!(:top, %{user_id: admin.id}),
      top_1m_ago: insert!(:song, %{due_date: Timex.shift(month_start, months: -1), user_id: admin.id, status: "voting"}),
      top_2m_ago: insert!(:song, %{due_date: Timex.shift(month_start, months: -2), user_id: admin.id, status: "counting"}),
      top_3m_ago: insert!(:song, %{due_date: Timex.shift(month_start, months: -3), user_id: admin.id, status: "published"}),
      top_4m_ago: insert!(:song, %{due_date: Timex.shift(month_start, months: -4), user_id: admin.id, status: "published"}),
      top_27m_ago: insert!(:song, %{due_date: Timex.shift(month_start, months: -27), user_id: admin.id, status: "published"}),
      top_28m_ago: insert!(:song, %{due_date: Timex.shift(month_start, months: -28), user_id: admin.id, status: "published"})
    }

    {:ok, tops: tops}
  end
end