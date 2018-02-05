defmodule WsdjsApi.V1.AccountControllerTest do
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
      assert json_response(conn, 200)["data"] == %{"id" => user.id, "admin" => user.admin, "country" => user.user_country, "djname" => user.djname, "email" => user.email, "name" => user.name, "profil_dj" => user.profil_dj, "verified_profil" => false}
    end

    test "renders current user", %{conn: conn} do
      _user = insert(:user)
      current_user = insert(:user)
      user_token = Phoenix.Token.sign(WsdjsWeb.Endpoint, "user", current_user.id)
      conn = put_req_header(conn, "authorization", "Bearer " <> user_token)

      conn = get conn, api_me_path(conn, :show)
      assert json_response(conn, 200)["data"] == %{
        "id" => current_user.id, 
        "admin" => current_user.admin, 
        "country" => current_user.user_country, 
        "djname" => current_user.djname, 
        "email" => current_user.email, 
        "name" => current_user.name, 
        "profil_dj" => current_user.profil_dj, 
        "verified_profil" => false
      }
    end
  end
end
