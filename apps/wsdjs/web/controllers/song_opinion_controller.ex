defmodule Wsdjs.SongOpinionController do
  use Wsdjs.Web, :controller

  plug :put_layout, false when action in [:create, :delete]

  def create(conn, %{"kind" => kind, "song_id" => song_id}) do
    user = conn.assigns[:current_user]
    song = Wcsp.find_song!(user, id: song_id)

    Wcsp.upsert_opinion!(user, song, kind)

    song = Wcsp.find_song!(user, id: song_id)

    conn |>
    render("_show.html", song: song)
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]

    song_opinion = Wcsp.find_song_opinion(id: id)
    Wcsp.delete_song_opinion!(user, id: id)

    song = Wcsp.find_song!(user, id: song_opinion.song_id)

    conn |>
    render("_show.html", song: song)
  end
end
