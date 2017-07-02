defmodule Wsdjs.Web.SearchController do
  use Wsdjs.Web, :controller

  plug :put_layout, false

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, %{"q" => q}) do
    current_user = conn.assigns[:current_user]
    songs = Wsdjs.Musics.search(current_user, q)

    render conn, "index.html", songs: songs
  end
end
