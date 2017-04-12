defmodule Wsdjs.SearchController do
  use Wsdjs, :controller

  plug :put_layout, false

  def index(conn, %{"q" => q}) do
    current_user = conn.assigns[:current_user]
    songs = Wcsp.Musics.search(current_user, q)

    render conn, "index.html", songs: songs
  end
end
