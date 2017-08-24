defmodule WsdjsWeb.Api.V1.OpinionController do
  @moduledoc false
  use WsdjsWeb, :controller

  plug :put_layout, false when action in [:create, :delete]

  def create(conn, %{"kind" => kind, "song_id" => song_id}) do
    current_user = conn.assigns[:current_user]

    Wsdjs.Musics.upsert_opinion(current_user, song_id, kind)

    song = Wsdjs.Musics.get_song!(current_user, song_id)
    opinions = Wsdjs.Musics.list_opinions(song_id)

    render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    opinion = Wsdjs.Musics.get_opinion!(id)
    {:ok, opinion} = Wsdjs.Musics.delete_opinion(opinion)

    song = Wsdjs.Musics.get_song!(current_user, opinion.song_id)
    opinions = Wsdjs.Musics.list_opinions(opinion.song_id)

    render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
  end
end
