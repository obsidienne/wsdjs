defmodule WsdjsWeb.ScrollingChannel do
  @moduledoc """
  This modules manage the infinite scroll behavior of song
  """
  use Phoenix.Channel

  alias Wsdjs.Musics
  alias Wsdjs.Playlists

  def join("scrolling:song", _message, socket) do
    {:ok, socket}
  end

  def join("scrolling:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("song", %{"month" => month, "q" => q}, socket) do
    current_user = socket.assigns[:current_user]

    month =
      month
      |> Timex.parse!("%Y-%m-%d", :strftime)
      |> Timex.to_date()

    songs = Musics.list_songs(current_user, month, "")

    next_month = Musics.songs_interval(current_user, month)
    IO.inspect(next_month)

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

  def handle_in("song", params, socket) do
    current_user = socket.assigns[:current_user]
    next_month = Musics.songs_interval(current_user)

    params = Map.put(params, "month", Timex.format!(next_month, "%Y-%m-%d", :strftime))

    handle_in("song", params, socket)
  end
end
