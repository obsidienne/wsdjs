defmodule WsdjsWeb.RadioChannel do
  @moduledoc """
  This modules notifies all radio clients when a new song is played.
  """
  use Phoenix.Channel

  Phoenix.Channel.intercept(["new_streamed_song"])

  def join("radio:streamed", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    json = WsdjsWeb.Service.RadioSrv.streamed(socket)
    push(socket, "new_streamed_song", %{data: json})
    {:noreply, socket}
  end

  def handle_info(:new_streamed_song, socket) do
    json = WsdjsWeb.Service.RadioSrv.streamed(socket)
    push(socket, "new_streamed_song", %{data: json})
    {:noreply, socket}
  end

  def handle_in("list_song", _, socket) do
    json = WsdjsWeb.Service.RadioSrv.streamed(socket)
    push(socket, "new_streamed_song", %{data: json})
    {:noreply, socket}
  end
end
