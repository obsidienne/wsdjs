defmodule Wsdjs.HottestController do
  use Wsdjs, :controller

  alias Wcsp.Musics.Song

  def index(conn, _params) do
    current_user = conn.assigns[:current_user]

    songs = Wcsp.Musics.list_songs(current_user)
    top = Wcsp.Trendings.last_top_10(current_user)

    render conn, "index.html", songs: songs, top: top
  end

  def new(conn, _params) do
    changeset = Song.changeset(%Song{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"song" => params}) do
    current_user = conn.assigns[:current_user]

    case Wcsp.Musics.create_song(current_user, params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, "#{song.title} created !")
        |> redirect(to: hottest_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
