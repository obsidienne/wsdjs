defmodule Wsdjs.SearchController do
  use Wsdjs, :controller

  plug :put_layout, false

  def index(conn, %{"q" => q}) do
    user = conn.assigns[:current_user]
    songs = Wcsp.Music.search(user, q)

    render conn, "index.html", songs: songs
  end
end
