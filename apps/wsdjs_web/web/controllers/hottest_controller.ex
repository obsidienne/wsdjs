defmodule WsdjsWeb.HottestController do
  use WsdjsWeb.Web, :controller

  plug :put_layout, false when action in [:create]

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    songs = Wcsp.hot_songs(user)
    changeset = Wcsp.Song.changeset(%Wcsp.Song{})

    render conn, "index.html", songs: songs, changeset: changeset
  end

  def create(conn, %{"song" => song_params}) do
    changeset = Wcsp.Song.changeset(%Wcsp.Song{}, song_params)

    case Wcsp.Repo.insert(changeset) do
      {:ok, song} -> conn
        |> put_flash(:info, "#{song.title} created!")
        |> redirect(to: hottest_path(conn, :index))
      {:error, changeset} ->
        render conn, "_add_song_modal.html", changeset: changeset
    end
  end
end
