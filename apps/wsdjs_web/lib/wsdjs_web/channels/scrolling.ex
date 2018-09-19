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

  def handle_in("song", %{"month" => month}, socket) do
    current_user = socket.assigns[:current_user]

    interval = Musics.songs_interval(current_user)
    playlists = Playlists.get_playlist_by_user(current_user, current_user)

    month =
      if is_nil(month) do
        interval[:max]
      else
        month
        |> Timex.parse!("%Y-%m-%d", :strftime)
        |> Timex.to_date()
        |> Timex.beginning_of_month()
      end

    songs = Musics.list_songs(current_user, month, "")

    tpl =
      Phoenix.View.render_to_string(
        WsdjsWeb.SongView,
        "index_ajax.html",
        conn: WsdjsWeb.Endpoint,
        songs: songs,
        current_user: current_user,
        month: month,
        playlists: playlists,
        last: Timex.before?(month, interval[:min])
      )

    broadcast!(socket, "song", %{tpl: tpl})

    {:noreply, socket}
  end
end
