defmodule WsdjsApi.OpinionController do
  @moduledoc false
  use WsdjsApi, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions.Opinions

  action_fallback(WsdjsApi.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"song_id" => song_id}, current_user) do
    with song <- Musics.Songs.get_song!(song_id) do
      opinions = Opinions.list(song)

      render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end

  def create(conn, %{"kind" => kind, "song_id" => song_id}, current_user) do
    with song <- Musics.Songs.get_song!(song_id),
         :ok <- Opinions.can?(current_user, :create, song),
         {:ok, _} <- Opinions.upsert(current_user, song, kind) do
      opinions = Opinions.list(song)

      conn
      |> put_status(:created)
      |> render("index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    with opinion <- Opinions.get!(id),
         :ok <- Opinions.can?(current_user, :delete, opinion),
         {:ok, opinion} = Opinions.delete(opinion) do
      song = Musics.Songs.get_song!(opinion.song_id)
      opinions = Opinions.list(song)
      render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end
end
