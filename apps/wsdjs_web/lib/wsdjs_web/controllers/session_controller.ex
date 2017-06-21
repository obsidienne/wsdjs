defmodule Wsdjs.Web.SessionController do
  use Wsdjs.Web, :controller

  plug :put_layout, "login.html"

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email}}) do
    Wsdjs.Web.MagicLink.provide_token(email)

    # do not leak information about (non-)existing users.
    # always reply with success message, even though the
    # user might not exist.
    conn
    |> put_flash(:info, "We have sent you a link for signing in via email to #{email}.")
    |> redirect(to: home_path(conn, :index))
  end

  @doc """
    Login user via magic link token.
    Sets the given user as `current_user` and updates the session.
  """
  def show(conn, %{"token" => token}) do
    case Wsdjs.Web.MagicLink.verify_magic_link(token) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_flash(:info, "You signed in successfully.")
        |> redirect(to: home_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "The login token is invalid.")
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
