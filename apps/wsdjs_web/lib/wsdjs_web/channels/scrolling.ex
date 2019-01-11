defmodule WsdjsWeb.ScrollingChannel do
  @moduledoc """
  This modules manage the infinite scroll behavior of song
  """
  use Phoenix.Channel

  alias Wsdjs.Musics

  def join("scrolling:song", _message, socket) do
    {:ok, socket}
  end

  def join("scrolling:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("song", nil, socket) do
    tpl =
      Phoenix.View.render_to_string(
        WsdjsWeb.SongView,
        "_no_song.html",
        conn: WsdjsWeb.Endpoint
      )

    broadcast!(socket, "song", %{tpl: tpl})

    {:noreply, socket}
  end

  def handle_in("song", %{"month" => month} = params, socket) do
    current_user = socket.assigns[:current_user]

    songs = Musics.Songs.list_songs(current_user, params)

    month = Timex.parse!(month, "%Y-%m-%d", :strftime)
    next_month = Musics.Songs.songs_interval(current_user, params)

    tpl =
      Phoenix.View.render_to_string(
        WsdjsWeb.SongView,
        "index_ajax.html",
        conn: WsdjsWeb.Endpoint,
        songs: songs,
        current_user: current_user,
        month: month,
        next_month: next_month
      )

    broadcast!(socket, "song", %{tpl: tpl})

    {:noreply, socket}
  end

  # this function is called when no month is given. Like during the first load
  # When we define the first month for the current_user we call the handle_in
  # function with the first song set and everything follows the same way
  # If there is no result then, we call handle_in with nil
  def handle_in("song", params, socket) do
    current_user = socket.assigns[:current_user]
    first_month = Musics.Songs.songs_interval(current_user, params)

    params =
      if is_nil(first_month) do
        nil
      else
        Map.put(params, "month", Timex.format!(first_month, "%Y-%m-%d", :strftime))
      end

    handle_in("song", params, socket)
  end
end
