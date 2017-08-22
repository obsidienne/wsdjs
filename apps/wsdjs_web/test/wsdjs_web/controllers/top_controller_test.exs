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
      delete(conn, top_path(conn, :delete, top.id))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "all user can access index", %{conn: conn} do
    Enum.each([
      assign(conn, :current_user, insert!(:user, %{admin: true})),
      assign(conn, :current_user, insert!(:user, %{profils: ["DJ_VIP"]})),
      assign(conn, :current_user, insert!(:user, %{profils: ["DJ"]})),
      assign(conn, :current_user, insert!(:user, %{profils: []})),
      assign(conn, :current_user, nil)
    ], fn conn ->
      conn = get conn, top_path(conn, :index)
      assert html_response(conn, 200) =~ "Tops - WSDJs"
    end)
  end

  describe "Index" do
    setup [:create_users]

    test "tops checking only visible by admin", %{conn: conn, users: users} do
      tops = Enum.map([0, -2, -3, -5, -27, -28], fn shift ->
        create_top(users[:admin], "checking", shift)
      end)

    end

    # visible by SECRET
    test "tops published from m to m-2", %{conn: conn, users: users} do
      top = create_top(users[:admin], "published", 0)
      top2 = create_top(users[:admin], "published", -2)
      
      Enum.each([
        assign(conn, :current_user, users[:admin]),
        assign(conn, :current_user, users[:dj_vip])
      ], fn conn ->
        conn = get conn, top_path(conn, :index)
        assert String.contains?(conn.resp_body, Date.to_iso8601(top.due_date))
        assert String.contains?(conn.resp_body, Date.to_iso8601(top2.due_date))
      end)

      Enum.each([
        assign(conn, :current_user, users[:dj]),
        assign(conn, :current_user, users[:user]),
        assign(conn, :current_user, nil)
      ], fn conn ->
        conn = get conn, top_path(conn, :index)
        refute String.contains?(conn.resp_body, Date.to_iso8601(top.due_date))
        refute String.contains?(conn.resp_body, Date.to_iso8601(top2.due_date))
      end)
    end

    # visible by PUBLIC, PRIVE, SECRET
    test "tops published from m-3 to m-5", %{conn: conn, users: users} do
      top = create_top(users[:admin], "published", -3)
      top2 = create_top(users[:admin], "published", -5)
      
      Enum.each([
        assign(conn, :current_user, users[:admin]),
        assign(conn, :current_user, users[:dj_vip]),
        assign(conn, :current_user, users[:dj]),
        assign(conn, :current_user, users[:user]),
        assign(conn, :current_user, nil)
      ], fn conn ->
        conn = get conn, top_path(conn, :index)
        assert String.contains?(conn.resp_body, Date.to_iso8601(top.due_date))
        assert String.contains?(conn.resp_body, Date.to_iso8601(top2.due_date))
      end)
    end

    # visible by PRIVE, SECRET
    test "tops published from m-3 to m-27", %{conn: conn, users: users} do
      top = create_top(users[:admin], "published", -3)
      top2 = create_top(users[:admin], "published", -27)
      
      Enum.each([
        assign(conn, :current_user, users[:admin]),
        assign(conn, :current_user, users[:dj_vip])
      ], fn conn ->
        conn = get conn, top_path(conn, :index)
        assert String.contains?(conn.resp_body, Date.to_iso8601(top.due_date))
        assert String.contains?(conn.resp_body, Date.to_iso8601(top2.due_date))
      end)

      Enum.each([
        assign(conn, :current_user, users[:dj]),
        assign(conn, :current_user, users[:user]),
        assign(conn, :current_user, nil)
      ], fn conn ->
        conn = get conn, top_path(conn, :index)
        refute String.contains?(conn.resp_body, Date.to_iso8601(top.due_date))
        refute String.contains?(conn.resp_body, Date.to_iso8601(top2.due_date))
      end)
    end

    # visible by SECRET
    test "tops published from m-28", %{conn: conn, users: users} do
      top = create_top(users[:admin], "published", -28)
      
      Enum.each([
        assign(conn, :current_user, users[:admin]),
        assign(conn, :current_user, users[:dj_vip])
      ], fn conn ->
        conn = get conn, top_path(conn, :index)
        assert String.contains?(conn.resp_body, Date.to_iso8601(top.due_date))
      end)

      Enum.each([
        assign(conn, :current_user, users[:dj]),
        assign(conn, :current_user, users[:user]),
        assign(conn, :current_user, nil)
      ], fn conn ->
        conn = get conn, top_path(conn, :index)
        refute String.contains?(conn.resp_body, Date.to_iso8601(top.due_date))
      end)
    end    
  end

  defp create_top(user, status, shift) do
    dt = Timex.today
    |> Timex.beginning_of_month()
    |> Timex.shift(months: shift)
    insert!(:top, %{user_id: user.id, status: status, due_date: dt})
  end

  defp create_users(_) do
    users = %{
      user: insert!(:user),
      user2: insert!(:user),
      dj: insert!(:user, profils: ["DJ"]),
      dj2: insert!(:user, profils: ["DJ"]),
      dj_vip: insert!(:user, profils: ["DJ_VIP"]),
      dj_vip2: insert!(:user, profils: ["DJ_VIP"]),
      admin: insert!(:user, %{admin: true})
    }

    {:ok, users: users}
  end  
end
