defmodule Wsdjs.HottestController do
  use Wsdjs.Web, :controller

  def index(conn, _params, current_user) do
    songs = Wcsp.hot_songs(current_user)
    top = Wcsp.last_top_10(current_user)

    render conn, "index.html", songs: songs, top: top
  end

  def new(conn, _params, _current_user) do
    changeset = Wcsp.Song.changeset(%Wcsp.Song{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"song" => params}, current_user) do
    case Wcsp.create_song(current_user, params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "#{song.title} created !")
        |> redirect(to: hottest_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def action(conn, _) do apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user]) end
end
