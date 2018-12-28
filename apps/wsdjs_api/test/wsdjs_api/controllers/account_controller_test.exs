defmodule WsdjsApi.AccountControllerTest do
  use WsdjsApi.ConnCase

  @create_attrs %{name: "John", email: "john@example.com"}

  defp create_user(_) do
    {:ok, user} = Wsdjs.Accounts.create_user(@create_attrs)
    {:ok, user: user}
  end

  describe "show/2" do
    setup [:create_user]

    test "Responds with user info if the user is found", %{conn: conn, user: user} do
      user_token = Phoenix.Token.sign(WsdjsApi.Endpoint, "user", user.id)

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> user_token)
        |> get(Routes.api_account_path(conn, :show, user.id))
        |> json_response(200)

      expected = %{
        "data" => %{
          "id" => user.id,
          "admin" => user.admin,
          "country" => user.user_country,
          "djname" => user.djname,
          "email" => user.email,
          "name" => user.name,
          "profil_dj" => user.profil_dj,
          "verified_profil" => false,
          "detail" => %{
            "description" => nil,
            "djing_start_year" => nil,
            "facebook" => nil,
            "favorite_animal" => nil,
            "favorite_artist" => nil,
            "favorite_color" => nil,
            "favorite_genre" => nil,
            "favorite_meal" => nil,
            "hate_more" => nil,
            "love_more" => nil,
            "soundcloud" => nil,
            "youtube" => nil
          }
        }
      }

      assert response == expected
    end

    test "Responds with user info if the current_user is found", %{conn: conn, user: user} do
      user_token = Phoenix.Token.sign(WsdjsApi.Endpoint, "user", user.id)

      response =
        conn
        |> put_req_header("authorization", "Bearer " <> user_token)
        |> get(Routes.api_me_path(conn, :show))
        |> json_response(200)

      expected = %{
        "data" => %{
          "id" => user.id,
          "admin" => user.admin,
          "country" => user.user_country,
          "djname" => user.djname,
          "email" => user.email,
          "name" => user.name,
          "profil_dj" => user.profil_dj,
          "verified_profil" => false,
          "detail" => %{
            "description" => nil,
            "djing_start_year" => nil,
            "facebook" => nil,
            "favorite_animal" => nil,
            "favorite_artist" => nil,
            "favorite_color" => nil,
            "favorite_genre" => nil,
            "favorite_meal" => nil,
            "hate_more" => nil,
            "love_more" => nil,
            "soundcloud" => nil,
            "youtube" => nil
          }
        }
      }

      assert response == expected
    end
  end
end
