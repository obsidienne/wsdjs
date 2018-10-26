defmodule WsdjsWeb.HomeController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Charts
  alias Wsdjs.Musics

  @spec index(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def index(conn, _params) do
    songs = Musics.instant_hits()
    top = Charts.last_top(conn.assigns.current_user)

    render(conn, "index.html", songs: songs, top: top)
  end
end
