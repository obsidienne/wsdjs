defmodule WsdjsWeb.Api.V1.SessionController do
  @moduledoc false
  use WsdjsWeb, :controller

  plug :put_layout, "login.html"

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User

  action_fallback WsdjsWeb.Api.V1.FallbackController

  def create(conn, %{"email" => email}) do
    with {:ok, %User{} = user} <- WsdjsWeb.MagicLink.provide_token(email, "api") do
      conn
      |> put_status(:created)
      |> send_resp(:no_content, "")
    end
  end

  def show(conn, %{"token" => token}) do
    with {:ok, %User{} = user} <- WsdjsWeb.MagicLink.verify_magic_link(token) do
      bearer = Phoenix.Token.sign(conn, "user", user.id)

      [avatar] = Accounts.get_avatar(user)
      render(conn, "show.json", user: user, avatar: avatar, bearer: bearer)
    end
  end
end
