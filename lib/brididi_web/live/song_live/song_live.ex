defmodule BrididiWeb.SongLive do
  use BrididiWeb, :live_view

  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket), temporary_assigns: [song: nil, opinions: []]}
  end

  def handle_params(%{"song_id" => song_id}, _url, socket) do
    current_user = socket.assigns[:current_user]

    song = Brididi.Musics.get_song!(song_id)
    opinions = Brididi.Reactions.Opinions.list(song)

    socket = assign(socket, song: song, opinions: opinions)

    {:noreply, socket}
  end
end
