defmodule Brididi.LiveHelpers do
  import Phoenix.LiveView

  alias Brididi.Accounts

  def assign_defaults(%{"user_token" => user_token}, socket) do
    socket =
      assign_new(socket, :current_user, fn -> Accounts.get_user_by_session_token(user_token) end)

    if socket.assigns.current_user.confirmed_at do
      socket
    else
      redirect(socket, to: "/login")
    end
  end
end
