defmodule BrididiWeb.TopControllerTest do
  use BrididiWeb.ConnCase
  alias Brididi.Accounts

  import Brididi.AccountsFixtures

  defp create_users(_) do
    god = %Accounts.User{admin: true}
    suggestor = user_fixture()
    {:ok, suggestor} = Accounts.update_user(suggestor, %{"name" => "suggestor"}, god)

    user = user_fixture()
    {:ok, user} = Accounts.update_user(user, %{"name" => "user"}, god)

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

    {:ok, suggestor: suggestor, user: user, dj: dj, djvip: djvip, admin: admin}
  end

  defp create_top(%{suggestor: suggestor}) do
    {:ok, top} =
      Brididi.Charts.create_top(%{
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
              get(conn, Routes.top_path(conn, :new)),
              put(conn, Routes.top_path(conn, :update, top.id, %{"direction" => "next"})),
              put(conn, Routes.top_path(conn, :update, top.id, %{"direction" => "previous"})),
              post(conn, Routes.top_path(conn, :create), top: %{due_date: Timex.today()}),
              delete(conn, Routes.top_path(conn, :delete, top.id))
            ],
            fn conn ->
              assert html_response(conn, 302)
            end
          )
        end
      )
    end
  end
end
