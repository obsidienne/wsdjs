defmodule WsdjsWeb.HomeController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.{Musics, Charts}

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) do
    songs = Musics.instant_hits()
    top = Charts.last_top(current_user)

    render conn, "index.html", songs: songs, top: top
  end
end
