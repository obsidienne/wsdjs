defmodule WsdjsWeb.HottestController do
  use WsdjsWeb.Web, :controller

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    songs = Wcsp.hot_songs(user)
    changeset = Wcsp.Song.changeset(%Wcsp.Song{})
    top = Wcsp.last_top_10(user)

    render conn, "index.html", songs: songs, top: top, changeset: changeset
  end

  def new(conn, _params) do
    changeset = Wcsp.Song.changeset(%Wcsp.Song{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"song" => params}) do
    user = conn.assigns[:current_user]

    case Wcsp.create_song(user, params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "#{song.title} created !")
        |> redirect(to: hottest_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
