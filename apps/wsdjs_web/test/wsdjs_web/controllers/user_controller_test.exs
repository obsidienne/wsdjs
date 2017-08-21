defmodule WsdjsWeb.UserControllerTest do
  use WsdjsWeb.ConnCase
  import WsdjsWeb.Factory

  test "requires user authentication on actions", %{conn: conn} do
    Enum.each([
      get(conn, user_path(conn, :index)),
      get(conn, user_path(conn, :edit, Ecto.UUID.generate())),
      put(conn, user_path(conn, :update, Ecto.UUID.generate(), %{}))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  describe "index" do
    setup [:create_users]

    test "lists all users", %{conn: conn, users: users} do
      # can list
      Enum.each([
        assign(conn, :current_user, users[:admin])
      ], fn conn ->
        conn = get conn, user_path(conn, :index)
        assert html_response(conn, 200) =~ "Users - WSDJs"
        assert String.contains?(conn.resp_body, users[:user].email)
      end)

      # cannot list
      Enum.each([
        assign(conn, :current_user, users[:user]),
        assign(conn, :current_user, users[:dj]),
        assign(conn, :current_user, users[:dj_vip])
      ], fn conn ->
        conn = get conn, user_path(conn, :index)
        assert html_response(conn, 302)
      end)
    end
  end

  describe "show user" do
    test "only admin can access show admin user", %{conn: conn} do
      admin = insert!(:user, %{admin: true})
      dj_vip = insert!(:user, %{profils: ["DJ_VIP"]})
      dj = insert!(:user, %{profils: ["DJ"]})
      user = insert!(:user)

      Enum.each([
        assign(conn, :current_user, insert!(:user, %{profils: ["DJ_VIP"]})),
        assign(conn, :current_user, insert!(:user, %{profils: ["DJ"]})),
        assign(conn, :current_user, insert!(:user)),
        assign(conn, :current_user, nil)
      ], fn conn ->
        conn = get conn, user_path(conn, :show, admin.id)
        assert html_response(conn, 302)
      end)

      conn = assign(conn, :current_user, insert!(:user, %{admin: true}))
      conn = get conn, user_path(conn, :show, admin.id)
      assert html_response(conn, 200) =~ "User - WSDJs"
      assert String.contains?(conn.resp_body, admin.email)
    end

    test "all user can access show std user", %{conn: conn} do
      admin = insert!(:user, %{admin: true})
      dj_vip = insert!(:user, %{profils: ["DJ_VIP"]})
      dj = insert!(:user, %{profils: ["DJ"]})
      user = insert!(:user)

      Enum.each([
        assign(conn, :current_user, insert!(:user, %{admin: true})),
        assign(conn, :current_user, insert!(:user, %{profils: ["DJ_VIP"]})),
        assign(conn, :current_user, insert!(:user, %{profils: ["DJ"]})),
        assign(conn, :current_user, insert!(:user)),
        assign(conn, :current_user, nil)
      ], fn conn ->
        conn_done = get conn, user_path(conn, :show, dj_vip.id)
        assert html_response(conn_done, 200) =~ "User - WSDJs"
        assert String.contains?(conn_done.resp_body, dj_vip.email)

        conn_done = get conn, user_path(conn, :show, dj.id)
        assert html_response(conn_done, 200) =~ "User - WSDJs"
        assert String.contains?(conn_done.resp_body, dj.email)

        conn_done = get conn, user_path(conn, :show, user.id)
        assert html_response(conn_done, 200) =~ "User - WSDJs"
        assert String.contains?(conn_done.resp_body, user.email)
      end)
    end
  end

  describe "edit user" do
    test "renders form for editing user", %{conn: conn, users: users} do
      user = insert!(:user)

      # can edit
      Enum.each([
        assign(conn, :current_user, user),
        assign(conn, :current_user, build(:user, %{admin: true}))
      ], fn conn ->
        conn = get conn, user_path(conn, :edit, user.id)
        assert html_response(conn, 200) =~ "Edit user - WSDJs"
        assert String.contains?(conn.resp_body, user.name)
      end)

      # cannot edit
      Enum.each([
        assign(conn, :current_user, build(:user)),
        assign(conn, :current_user, build(:user, %{profils: ["DJ"]})),
        assign(conn, :current_user, build(:user, %{profils: ["DJ_VIP"]}))
      ], fn conn ->
        conn = get conn, user_path(conn, :edit, user.id)
        assert html_response(conn, 302)
      end)
    end
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
