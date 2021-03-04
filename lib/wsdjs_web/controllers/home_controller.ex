defmodule BrididiWeb.HomeController do
  @moduledoc false
  use BrididiWeb, :controller

  alias Brididi.Charts
  alias Brididi.Musics

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    songs = Musics.instant_hits()
    songs = Brididi.Accounts.load_user_profil_for_songs(songs)

    tops = Charts.last_tops(conn.assigns.current_user)
    users = Brididi.Accounts.list_djs()

    render(conn, "index.html", songs: songs, tops: tops, users: users)
  end
end
