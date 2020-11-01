defmodule WsdjsWeb.UserControllerTest do
  use WsdjsWeb.ConnCase
  alias Wsdjs.Accounts
  import Wsdjs.AccountsFixtures

  test "requires user authentication on actions", %{conn: conn} do
    Enum.each(
      [
        get(conn, Routes.user_path(conn, :edit, Ecto.UUID.generate())),
        put(conn, Routes.user_path(conn, :update, Ecto.UUID.generate(), %{}))
      ],
      fn conn ->
        assert html_response(conn, 302)
        assert conn.halted
      end
    )
  end

  defp create_users(_) do
    god = %Accounts.User{admin: true}
    user = user_fixture()
    {:ok, user} = Accounts.update_user(user, %{"name" => "user"}, god)

    user2 = user_fixture()
    {:ok, user2} = Accounts.update_user(user2, %{"name" => "user2"}, god)

    dj = user_fixture()
    {:ok, dj} = Accounts.update_user(dj, %{"name" => "dj", "profil_dj" => true}, god)

    djvip = user_fixture()
    {:ok, djvip} = Accounts.update_user(djvip, %{"name" => "djvip", "profil_djvip" => true}, god)

    admin = user_fixture()

    {:ok, admin} =
      Accounts.update_user(
        admin,
        %{"name" => "admin", "admin" => true},
        god
      )

    {:ok, user: user, user2: user2, dj: dj, djvip: djvip, admin: admin}
  end

  describe "index/2" do
    setup [:create_users]

    test "lists all users", %{conn: conn, user: user, dj: dj, djvip: djvip, admin: admin} do
      Enum.each(
        [
          assign(conn, :current_user, admin)
        ],
        fn conn ->
          conn = get(conn, Routes.user_path(conn, :index))
          assert html_response(conn, 200) =~ "List users - World Swing DJs"
          assert String.contains?(conn.resp_body, user.email)
          assert String.contains?(conn.resp_body, dj.email)
          assert String.contains?(conn.resp_body, djvip.email)
          assert String.contains?(conn.resp_body, admin.email)
        end
      )

      # cannot list
      Enum.each(
        [
          assign(conn, :current_user, user),
          assign(conn, :current_user, djvip),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, nil)
        ],
        fn conn ->
          conn = get(conn, Routes.user_path(conn, :index))
          assert html_response(conn, 302)
        end
      )
    end
  end

  describe "show/2" do
    setup [:create_users]

    test "Responds with admin info if user authorized", %{
      conn: conn,
      user: user,
      dj: dj,
      djvip: djvip,
      admin: admin
    } do
      Enum.each(
        [
          assign(conn, :current_user, user),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, djvip),
          assign(conn, :current_user, nil)
        ],
        fn conn ->
          conn = get(conn, Routes.user_path(conn, :show, admin.id))
          assert html_response(conn, 302)
        end
      )

      response =
        conn
        |> assign(:current_user, admin)
        |> get(Routes.user_path(conn, :show, admin))
        |> html_response(200)

      assert String.contains?(response, "User - World Swing DJs")
      assert String.contains?(response, admin.email)
    end

    test "Responds with user info if the user is found", %{
      conn: conn,
      user: user,
      dj: dj,
      djvip: djvip,
      admin: admin
    } do
      Enum.each(
        [
          assign(conn, :current_user, admin),
          assign(conn, :current_user, djvip),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, user),
          assign(conn, :current_user, nil)
        ],
        fn conn ->
          response =
            conn
            |> get(Routes.user_path(conn, :show, djvip.id))
            |> html_response(200)

          djvip_profil = Accounts.get_profil_by_user(djvip)
          assert String.contains?(response, djvip_profil.name)

          response =
            conn
            |> get(Routes.user_path(conn, :show, dj.id))
            |> html_response(200)

          dj_profil = Accounts.get_profil_by_user(dj)
          assert String.contains?(response, dj_profil.name)

          response =
            conn
            |> get(Routes.user_path(conn, :show, user.id))
            |> html_response(200)

          user_profil = Accounts.get_profil_by_user(user)
          assert String.contains?(response, user_profil.name)
        end
      )
    end
  end

  describe "update/2" do
    setup [:create_users]

    test "renders form for editing user", %{
      conn: conn,
      user: user,
      user2: user2,
      dj: dj,
      djvip: djvip,
      admin: admin
    } do
      # can edit
      Enum.each(
        [
          assign(conn, :current_user, user),
          assign(conn, :current_user, admin)
        ],
        fn conn ->
          conn = get(conn, Routes.user_path(conn, :edit, user))
          assert html_response(conn, 200) =~ "Edit user - World Swing DJs"
          assert String.contains?(conn.resp_body, user.name)
        end
      )

      # cannot edit
      Enum.each(
        [
          assign(conn, :current_user, user2),
          assign(conn, :current_user, dj),
          assign(conn, :current_user, djvip)
        ],
        fn conn ->
          conn = get(conn, Routes.user_path(conn, :edit, user.id))
          assert html_response(conn, 302)
        end
      )
    end

    test "admin can edit admin fields", %{
      conn: conn,
      user: user,
      admin: admin
    } do
      refute user.profil_djvip
      refute user.profil_dj
      refute user.admin

      params = %{profil_djvip: true, profil_dj: true, admin: true}

      conn
      |> assign(:current_user, admin)
      |> put(Routes.user_path(conn, :update, user.id, %{"user" => params}))

      user_updated = Wsdjs.Accounts.get_user!(user.id)
      assert user_updated.profil_djvip
      assert user_updated.profil_dj
      assert user_updated.admin
    end

    test "user can edit himself", %{conn: conn, user: user} do
      params = %{
        profil_djvip: true,
        profil_dj: true,
        admin: true,
        profil: %{djname: "DJ has been", description: "J'aurai voulu être un artist"}
      }

      # change values
      conn
      |> assign(:current_user, user)
      |> put(Routes.user_path(conn, :update, user, %{"user" => params}))

      user_updated = Wsdjs.Accounts.get_user!(user.id)
      user_profil = Wsdjs.Accounts.get_profil_by_user(user_updated)

      assert user_profil.djname == "DJ has been"
      assert user_profil.description == "J'aurai voulu être un artist"
      refute user_updated.user_profil_djvip
      refute user_updated.profil_dj
      refute user_updated.admin
    end
  end
end
