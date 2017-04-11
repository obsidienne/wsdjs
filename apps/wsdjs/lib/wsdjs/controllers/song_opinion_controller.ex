defmodule Wsdjs.SongOpinionController do
  use Wsdjs, :controller

  plug :put_layout, false when action in [:create, :delete]

  def create(conn, %{"kind" => kind, "song_id" => song_id}) do
    user = conn.assigns[:current_user]
    song = Wcsp.Musics.find_song!(user, id: song_id)

    Wcsp.Musics.upsert_opinion!(user, song, kind)

    song = Wcsp.Musics.find_song!(user, id: song_id)

    conn |>
    render("_show.html", song: song)
  end

  def delete(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]

    opinion = Wcsp.Musics.get_opinion!(id)
    {:ok, opinion} = Wcsp.Musics.delete_opinion(opinion)

    song = Wcsp.Musics.find_song!(user, id: opinion.song_id)

    conn |>
    render("_show.html", song: song)
  end
end
