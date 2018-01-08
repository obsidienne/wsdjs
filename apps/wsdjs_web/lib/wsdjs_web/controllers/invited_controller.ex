defmodule WsdjsWeb.InvitedController do
  @moduledoc false
  use WsdjsWeb, :controller

  def show(conn, %{"token" => token}) do
    case WsdjsWeb.MagicLink.verify_invited_link(token) do
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
end
