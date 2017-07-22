defmodule Wsdjs.Web.HomeController do
  @moduledoc false
  use Wsdjs.Web, :controller

  alias Wsdjs.{Musics, Trendings}

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, nil) do
    render conn, "unauthenticated.html"
  end


  def index(conn, _params, current_user) do
    songs = Musics.hot_songs(current_user)
    top = Trendings.last_top(current_user)

    render conn, "index.html", songs: songs, top: top
  end
end
