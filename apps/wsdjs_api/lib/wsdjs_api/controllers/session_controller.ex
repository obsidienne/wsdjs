defmodule WsdjsApi.SessionController do
  @moduledoc false
  use WsdjsApi, :controller

  alias Wsdjs.Accounts.User

  action_fallback(WsdjsApi.FallbackController)

  def create(conn, %{"email" => email}) do
    with {:ok, %User{}} <- WsdjsWeb.MagicLink.provide_token(email, "api") do
      conn
      |> put_status(:created)
      |> send_resp(:no_content, "")
    end
  end

  def show(conn, %{"token" => token}) do
    with {:ok, %User{} = user} <- WsdjsWeb.MagicLink.verify_magic_link(token),
         {:ok, %User{} = user} <- Wsdjs.Auth.first_auth(user) do
      bearer = Phoenix.Token.sign(conn, "user", user.id)

      [avatar] = Wsdjs.Attachments.get_avatar(user)
      render(conn, "show.json", user: user, avatar: avatar, bearer: bearer)
    end
  end
end
