defmodule WsdjsWeb.SessionController do
  @moduledoc false
  use WsdjsWeb, :controller

  plug :put_layout, "login.html"

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.Invitation

  def new(conn, _) do
    changeset = Accounts.change_invitation(%Invitation{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"session" => %{"email" => email}}) do
    case WsdjsWeb.MagicLink.provide_token(email) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "We have sent you a link for signing in via email to #{email}.")
        |> redirect(to: home_path(conn, :index))
      {:error, :not_found} ->
        conn
        |> put_flash(:error, "Email #{email} is not registered. Send an email to worldswingdjs@gmail.com to ask for registration.")
        |> redirect(to: session_path(conn, :new))
    end
  end

  def show(conn, %{"token" => token}) do
    case WsdjsWeb.MagicLink.verify_magic_link(token) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "You signed in successfully.")
        |> redirect(to: home_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "The magic link is expired or already used. You should resend a magic link.")
        |> redirect(to: session_path(conn, :new))
     end
  end

  def delete(conn, _) do
    conn
    |> assign(:current_user, nil)
    |> configure_session(drop: true)
    |> delete_session(:user_id)
    |> put_flash(:info, "You logged out successfully. Enjoy your day!")
    |> redirect(to: home_path(conn, :index))
  end
end
