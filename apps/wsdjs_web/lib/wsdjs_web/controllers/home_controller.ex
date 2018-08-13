defmodule WsdjsWeb.HomeController do
  @moduledoc false
  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Charts
  alias Wsdjs.Musics

  @spec index(Plug.Conn.t(), any(), nil | Wsdjs.Accounts.User.t()) :: Plug.Conn.t()
  def index(conn, _params, current_user) do
    songs = Musics.instant_hits()
    top = Charts.last_top(current_user)

    render(conn, "index.html", songs: songs, top: top)
  end
end
