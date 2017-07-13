defmodule Wsdjs.Web.HomeController do
  @moduledoc false
  use Wsdjs.Web, :controller

  alias Wsdjs.{Musics, Trendings}

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    songs = Musics.hot_songs(current_user)
    top = Trendings.last_top(current_user)

    render conn, "index.html", songs: songs, top: top
  end

end
