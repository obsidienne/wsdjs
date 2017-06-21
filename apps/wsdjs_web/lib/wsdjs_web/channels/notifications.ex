defmodule Wsdjs.Web.NotificationsChannel do
  use Phoenix.Channel

  Phoenix.Channel.intercept(["new_played_song"])

  def join("notifications:now_playing", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end
  def join("room:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("played_song_list", _, socket) do
    pid = Process.whereis(Wsdjs.NowPlaying)
    list = Wsdjs.NowPlaying.read(pid)
    json = Poison.encode!(list)

    push socket, "new_played_song", %{data: json}

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    pid = Process.whereis(Wsdjs.NowPlaying)
    list = Wsdjs.NowPlaying.read(pid)
    json = Poison.encode!(list)

    push socket, "new_played_song", %{data: json}
    {:noreply, socket}
  end

  def handle_info(:new_played_song, socket) do
    pid = Process.whereis(Wsdjs.NowPlaying)
    list = Wsdjs.NowPlaying.read(pid)
    json = Poison.encode!(list)

    push socket, "new_played_song", %{data: json}
    {:noreply, socket}
  end
end
