defmodule WsdjsWeb.RegistrationController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Accounts.User

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"signup" => %{"email" => email}}) do
    with {:ok, %User{}} <- WsdjsWeb.MagicLink.provide_token(email, "browser") do
      conn
      |> put_flash(:info, "Check your email inboxWe have sent you a link for signing in via email to #{email}.")
      |> redirect(to: home_path(conn, :index))
    else
      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Email #{email} is deactivated. Send an email to worldswingdjs@gmail.com to ask for details.")
        |> redirect(to: session_path(conn, :new))
    end
  end
end