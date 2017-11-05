defmodule WsdjsWeb.Api.V1.OpinionController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Musics.Song
  alias Wsdjs.Reactions

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

    with song <- Musics.get_song!(song_id),
         :ok <- Reactions.Policy.can?(current_user, :create_opinion, song),
         {:ok, %Reactions.Opinion{}} <- Reactions.upsert_opinion(current_user, song, kind) do

      opinions = Reactions.list_opinions(song)

      conn
      |> put_status(:created)
      |> render("index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    with opinion <- Reactions.get_opinion!(id),
         :ok <- Reactions.Policy.can?(current_user, :delete, opinion),
         {:ok, opinion} = Reactions.delete_opinion(opinion) do

      song = Musics.get_song!(opinion.song_id)
      opinions = Reactions.list_opinions(song)
      render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end
end
