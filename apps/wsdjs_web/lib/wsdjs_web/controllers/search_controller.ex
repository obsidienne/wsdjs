defmodule WsdjsWeb.SearchController do
  @moduledoc false
  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  plug(:put_layout, false)

  def index(conn, %{"q" => q}, current_user) do
    songs = Wsdjs.Searches.search(current_user, q)

    render(conn, "index.html", songs: songs)
  end
end
