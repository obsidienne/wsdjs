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

  describe "edit user" do
    setup [:create_users]

    test "renders form for editing chosen user", %{conn: conn, users: users} do
      # can edit
      Enum.each([
        assign(conn, :current_user, users[:user]),
        assign(conn, :current_user, users[:admin])
      ], fn conn ->
        conn = get conn, user_path(conn, :edit, users[:user])
        assert html_response(conn, 200) =~ "John Doe"
      end)

      # cannot edit
      Enum.each([
        assign(conn, :current_user, users[:user2]),
        assign(conn, :current_user, users[:dj]),
        assign(conn, :current_user, users[:dj2]),
        assign(conn, :current_user, users[:dj_vip]),
        assign(conn, :current_user, users[:dj_vip2])
      ], fn conn ->
        conn = get conn, user_path(conn, :edit, users[:user])
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
