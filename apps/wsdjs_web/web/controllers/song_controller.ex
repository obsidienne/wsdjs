defmodule WsdjsWeb.SongController do
  use WsdjsWeb.Web, :controller

  def show(conn, %{"id" => id}) do
    song = Wcsp.Dj.find_song(id)

    render conn, "show.html", song: song
  end
end
