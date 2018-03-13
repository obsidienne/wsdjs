defmodule WsdjsWeb.UserControllerTest do
  use WsdjsWeb.ConnCase
  import Wsdjs.Factory

  test "requires user authentication on actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, user_path(conn, :edit, Ecto.UUID.generate())),
        put(conn, user_path(conn, :update, Ecto.UUID.generate(), %{}))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      user = insert(:user)
      dj = insert(:user, profil_dj: true)
      dj_vip = insert(:user, profil_djvip: true)
      admin = insert(:user, %{admin: true})

      # can list
      Enum.each(
        [
          assign(conn, :current_user, admin),
          assign(conn, :current_user, dj_vip)
        ],
        fn conn ->
          conn = get(conn, user_path(conn, :index))
          assert html_response(conn, 200) =~ "Users - WSDJs"
          assert String.contains?(conn.resp_body, user.email)
          assert String.contains?(conn.resp_body, dj.email)
          assert String.contains?(conn.resp_body, dj_vip.email)
          assert String.contains?(conn.resp_body, admin.email)
        end
      )

      # cannot list
      Enum.each(
        [
          assign(conn, :current_user, user),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, nil)
        ],
        fn conn ->
          conn = get(conn, user_path(conn, :index))
          assert html_response(conn, 302)
        end
      )
    end
  end

  describe "show user" do
    test "only admin can access show admin user", %{conn: conn} do
      user = insert(:user)
      dj = insert(:user, profil_dj: true)
      dj_vip = insert(:user, profil_djvip: true)
      admin = insert(:user, %{admin: true})

      admin = admin |> Wsdjs.Repo.preload(:parameter)
      Wsdjs.Accounts.update_user(admin, %{"parameter" => %{email_contact: true}}, admin)

      Enum.each(
        [
          assign(conn, :current_user, user),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, dj_vip),
          assign(conn, :current_user, nil)
        ],
        fn conn ->
          conn = get(conn, user_path(conn, :show, admin.id))
          assert html_response(conn, 302)
        end
      )

      conn = assign(conn, :current_user, admin)
      conn = get(conn, user_path(conn, :show, admin.id))
      assert html_response(conn, 200) =~ "User - WSDJs"
      assert String.contains?(conn.resp_body, admin.email)
    end

    test "all user can access show std user", %{conn: conn} do
      user = insert(:user) |> Wsdjs.Repo.preload([:detail, :parameter])
      dj = insert(:user, profil_dj: true) |> Wsdjs.Repo.preload([:detail, :parameter])
      dj_vip = insert(:user, profil_djvip: true) |> Wsdjs.Repo.preload([:detail, :parameter])
      admin = insert(:user, %{admin: true}) |> Wsdjs.Repo.preload([:detail, :parameter])

      attrs = %{"parameter" => %{email_contact: true}, "detail" => %{description: "aaa"}}
      Wsdjs.Accounts.update_user(dj, attrs, dj)
      Wsdjs.Accounts.update_user(user, attrs, user)
      Wsdjs.Accounts.update_user(dj_vip, attrs, dj_vip)

      Enum.each(
        [
          assign(conn, :current_user, admin),
          assign(conn, :current_user, dj_vip),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, user),
          assign(conn, :current_user, nil)
        ],
        fn conn ->
          conn_done = get(conn, user_path(conn, :show, dj_vip.id))
          assert html_response(conn_done, 200) =~ "User - WSDJs"
          assert String.contains?(conn_done.resp_body, dj_vip.email)

          conn_done = get(conn, user_path(conn, :show, dj.id))
          assert html_response(conn_done, 200) =~ "User - WSDJs"
          assert String.contains?(conn_done.resp_body, dj.email)

          conn_done = get(conn, user_path(conn, :show, user.id))
          assert html_response(conn_done, 200) =~ "User - WSDJs"
          assert String.contains?(conn_done.resp_body, user.email)
        end
      )
    end
  end

  describe "edit user" do
    test "renders form for editing user", %{conn: conn} do
      user = insert(:user)
      user2 = insert(:user)
      dj = insert(:user, profil_dj: true)
      dj_vip = insert(:user, profil_djvip: true)
      admin = insert(:user, %{admin: true})

      # can edit
      Enum.each(
        [
          assign(conn, :current_user, user),
          assign(conn, :current_user, admin)
        ],
        fn conn ->
          conn = get(conn, user_path(conn, :edit, user.id))
          assert html_response(conn, 200) =~ "Edit user - WSDJs"
          assert String.contains?(conn.resp_body, user.name)
        end
      )

      # cannot edit
      Enum.each(
        [
          assign(conn, :current_user, user2),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, dj_vip)
        ],
        fn conn ->
          conn = get(conn, user_path(conn, :edit, user.id))
          assert html_response(conn, 302)
        end
      )
    end
  end

  test "admin can edit admin fields", %{conn: conn} do
    user = insert(:user)
    admin = insert(:user, %{admin: true})
    refute user.profil_djvip
    refute user.profil_dj
    refute user.admin

    params = %{profil_djvip: true, profil_dj: true, admin: true}

    # change values
    conn
    |> assign(:current_user, admin)
    |> put(user_path(conn, :update, user.id, %{"user" => params}))

    user_updated = Wsdjs.Accounts.get_user!(user.id)
    assert user_updated.profil_djvip
    assert user_updated.profil_dj
    assert user_updated.admin
  end

  test "user can edit himself", %{conn: conn} do
    user = insert(:user)

    params = %{
      profil_djvip: true,
      profil_dj: true,
      admin: true,
      djname: "DJ has been",
      detail: %{description: "J'aurai voulu être un artist"}
    }

    # change values
    conn
    |> assign(:current_user, user)
    |> put(user_path(conn, :update, user.id, %{"user" => params}))

    user_updated = Wsdjs.Accounts.get_user!(user.id)
    assert user_updated.djname == "DJ has been"
    assert user_updated.detail.description == "J'aurai voulu être un artist"
    # refute user_updated.profil_djvip
    # refute user_updated.profil_dj
    # refute user_updated.admin
  end
end
