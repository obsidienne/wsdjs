defmodule WsdjsWeb.Api.V1.OpinionController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions

  plug :put_layout, false when action in [:create, :delete]

  action_fallback WsdjsWeb.Api.V1.FallbackController
  
  def index(conn, %{"song_id" => song_id}) do
    current_user = conn.assigns[:current_user]
    
    with song <- Musics.get_song!(song_id) do
      opinions = Reactions.list_opinions(song)
      
      render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end

  def create(conn, %{"kind" => kind, "song_id" => song_id}) do
    current_user = conn.assigns[:current_user]

    song = Musics.get_song!(song_id)
    Reactions.upsert_opinion(current_user, song, kind)
    opinions = Reactions.list_opinions(song)

    render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    opinion = Reactions.get_opinion!(id)
    {:ok, opinion} = Reactions.delete_opinion(opinion)

    song = Musics.get_song!(opinion.song_id)
    opinions = Reactions.list_opinions(song)

    render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
  end
end
