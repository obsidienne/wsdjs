defmodule Wsdjs.HottestController do
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

  @doc """
  No authZ needed, this function does not modify the database
  """
  def new(conn, _params) do
    changeset = Wcsp.Musics.Song.changeset(%Wcsp.Musics.Song{})
    render(conn, "new.html", changeset: changeset)
  end


  def create(conn, %{"song" => params}) do
    current_user = conn.assigns[:current_user]

    case Wcsp.Musics.create_song(current_user, params) do
      {:ok, song} ->
        conn
        |> put_flash(:info, %{title: "#{song.title}", body: "song created"})
        |> redirect(to: hottest_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
