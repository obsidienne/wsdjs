defmodule WsdjsWeb.HomeController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Charts
  alias Wsdjs.Musics

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    songs = Musics.instant_hits()
    songs = Wsdjs.Accounts.load_user_profil_for_songs(songs)

    tops = Charts.last_tops(conn.assigns.current_user)
    users = Wsdjs.Accounts.list_djs()

    render(conn, "index.html", songs: songs, tops: tops, users: users)
  end
end
