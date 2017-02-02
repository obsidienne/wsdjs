defmodule WsdjsWeb.SongController do
  use WsdjsWeb.Web, :controller

  def show(conn, %{"id" => id}) do
    song = Wcsp.find_song!(id: id)

    render conn, "show.html", song: song
  end
end
