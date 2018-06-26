defmodule WsdjsWeb.TopControllerTest do
  use WsdjsWeb.ConnCase
  alias Wsdjs.Accounts

  defp create_users(_) do
    god = %Accounts.User{admin: true}
    {:ok, suggestor} = Wsdjs.Accounts.create_user(%{"email" => "suggestor@wsdjs.com"})
    {:ok, suggestor} = Accounts.update_user(suggestor, %{"name" => "suggestor"}, god)

    {:ok, user} = Wsdjs.Accounts.create_user(%{"email" => "user@wsdjs.com"})
    {:ok, user} = Accounts.update_user(user, %{"name" => "user"}, god)

    {:ok, dj} = Wsdjs.Accounts.create_user(%{"email" => "dj@wsdjs.com"})
    {:ok, dj} = Accounts.update_user(dj, %{"name" => "dj", "profil_dj" => true}, god)

    {:ok, djvip} = Wsdjs.Accounts.create_user(%{"email" => "djvip@wsdjs.com"})
    {:ok, djvip} = Accounts.update_user(djvip, %{"name" => "djvip", "profil_djvip" => true}, god)

    {:ok, admin} = Wsdjs.Accounts.create_user(%{"name" => "admin", "email" => "admin@wsdjs.com"})

    {:ok, admin} =
      Accounts.update_user(
        admin,
        %{"name" => "admin", "admin" => true, "parameter" => %{email_contact: true}},
        god
      )

    {:ok, suggestor: suggestor, user: user, dj: dj, djvip: djvip, admin: admin}
  end

  defp create_top(%{suggestor: suggestor}) do
    {:ok, top} =
      Wsdjs.Charts.create_top(%{
        due_date: Timex.beginning_of_month(Timex.today()),
        user_id: suggestor.id
      })

    {:ok, top: top}
  end

  describe "access" do
    setup [:create_users, :create_top]

    test "STD users cannot alter a top", %{
      conn: conn,
      top: top,
      user: user,
      dj: dj,
      djvip: djvip
    } do
      Enum.each(
        [
          user,
          dj,
          djvip,
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

    test "all user can access index", %{
      conn: conn,
      user: user,
      djvip: djvip,
      admin: admin
    } do
      Enum.each(
        [
          assign(conn, :current_user, admin),
          assign(conn, :current_user, djvip),
          assign(conn, :current_user, user),
          assign(conn, :current_user, nil)
        ],
        fn conn ->
          conn = get(conn, top_path(conn, :index))
          assert html_response(conn, 200) =~ "List tops - World Swing DJs"
        end
      )
    end
  end
end
