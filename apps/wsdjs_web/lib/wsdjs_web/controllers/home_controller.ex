defmodule Wsdjs.Web.HomeController do
  @moduledoc false
  use Wsdjs.Web, :controller

  alias Wsdjs.{Musics, Charts}

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns[:current_user]]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, current_user) when is_nil(current_user) do
    songs = Musics.last_songs(current_user)

    render conn, "unauthenticated.html", songs: songs
  end

  def index(conn, _params, current_user) do
    songs = Musics.hot_songs(current_user)
    top = Charts.last_top(current_user)

    render conn, "index.html", songs: songs, top: top
  end
end
