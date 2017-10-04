defmodule WsdjsWeb.Api.V1.SessionController do
  @moduledoc false
  use WsdjsWeb, :controller

  plug :put_layout, "login.html"

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

  action_fallback WsdjsWeb.Api.V1.FallbackController

  def create(conn, %{"email" => email}) do
    with {:ok, %User{} = user} <- WsdjsWeb.MagicLink.provide_token(email) do
      conn
      |> put_status(:created)
      |> send_resp(:no_content, "")
    end
  end

  def show(conn, %{"token" => token}) do
    case WsdjsWeb.MagicLink.verify_magic_link(token) do
      {:ok, user} ->
        list = %{
          user: %{
            name: user.name,
            id: user.id        
          },
          bearer: Phoenix.Token.sign(conn, "user", user.id)
        }
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(200, Poison.encode!(list))

      {:error, _reason} ->
        list = %{
          error: "The magic link is expired or already used. You should resend a magic link."
        }
        conn
        |> put_resp_header("content-type", "application/json; charset=utf-8")
        |> send_resp(400, Poison.encode!(list))
     end
  end

  def delete(conn, %{"id" => id}) do
    list = %{
      message: "You logged out successfully. Enjoy your day!"
    }

    #conn
    #|> assign(:current_user, nil)
    #|> configure_session(drop: true)
    #|> delete_session(id)

    conn
    |> put_resp_header("content-type", "application/json; charset=utf-8")
    |> send_resp(200, Poison.encode!(list))
  end
end
