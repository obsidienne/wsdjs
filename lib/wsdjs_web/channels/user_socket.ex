defmodule WsdjsWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  # channel "room:*", WsdjsWeb.RoomChannel
  channel("notifications:*", WsdjsWeb.NotificationsChannel)
  channel("radio:*", WsdjsWeb.RadioChannel)
  channel("scrolling:*", WsdjsWeb.ScrollingChannel)

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @max_age 24 * 60 * 60
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "user", token, max_age: @max_age) do
      {:ok, user_id} ->
        user = if user_id, do: Wsdjs.Accounts.get_activated_user!(user_id)
        {:ok, assign(socket, :current_user, user)}

      {:error, _reason} ->
        {:ok, assign(socket, :current_user, nil)}
    end
  end

  def connect(_params, _socket), do: :error

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     WsdjsWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
