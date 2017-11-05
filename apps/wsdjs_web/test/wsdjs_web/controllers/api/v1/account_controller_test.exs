defmodule WsdjsWeb.Api.V1.AccountControllerTest do
  use WsdjsWeb.ConnCase
  import Wsdjs.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "users" do
    test "renders users by id", %{conn: conn} do
      user = insert(:user)
      user_token = Phoenix.Token.sign(WsdjsWeb.Endpoint, "user", user.id)
      conn = put_req_header(conn, "authorization", "Bearer " <> user_token)

      conn = get conn, api_account_path(conn, :show, user.id)
      assert json_response(conn, 200)["data"] == %{"id" => user.id, "admin" => user.admin, "country" => user.user_country, "djname" => user.djname, "email" => user.email, "name" => user.name, "profil_dj" => user.profil_dj}
    end
  end
end
