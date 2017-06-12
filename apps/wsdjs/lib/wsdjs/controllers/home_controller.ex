defmodule Wsdjs.HomeController do
  use Wsdjs, :controller

  @doc """
  No authZ needed, data is scoped by current_user
  """
  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    songs = Wcsp.Musics.hot_songs(current_user)
    top = Wcsp.Trendings.last_top(current_user)

    render conn, "index.html", songs: songs, top: top
  end

end
