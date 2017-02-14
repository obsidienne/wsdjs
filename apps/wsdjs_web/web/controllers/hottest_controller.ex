defmodule WsdjsWeb.HottestController do
  use WsdjsWeb.Web, :controller

  plug :put_layout, false when action in [:create]

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    songs = Wcsp.hot_songs(user)
    changeset = Wcsp.Song.changeset(%Wcsp.Song{})

    render conn, "index.html", songs: songs, changeset: changeset
  end

  def create(conn, %{"song" => params}) do
    user = conn.assigns[:current_user]

    case Wcsp.create_song(user, params) do
      {:ok, song} ->
        render conn, "_hot_card.html", song: song
      {:error, changeset} ->
        render(conn, "_add_song_modal.html", changeset: changeset)
    end
  end
end
