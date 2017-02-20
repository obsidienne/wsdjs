defmodule WsdjsWeb.SongOpinionController do
  use WsdjsWeb.Web, :controller

  plug :put_layout, false when action in [:create]

  def create(conn, %{"kind" => kind, "song_id" => song_id}) do
    user = conn.assigns[:current_user]

    song = Wcsp.find_song!(user, id: song_id)

    conn |>
    render("_show.html", song: song)
  end
end
