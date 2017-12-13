defmodule WsdjsWeb.SearchController do
  @moduledoc false
  use WsdjsWeb, :controller

  plug :put_layout, false

  def index(conn, %{"q" => q}) do
    current_user = conn.assigns[:current_user]
    songs = Wsdjs.Searches.search(current_user, q)

    render conn, "index.html", songs: songs
  end
end
