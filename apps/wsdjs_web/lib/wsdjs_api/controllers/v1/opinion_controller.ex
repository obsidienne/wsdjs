defmodule WsdjsApi.V1.OpinionController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Reactions.Opinions

  action_fallback(WsdjsApi.V1.FallbackController)

  def index(conn, %{"song_id" => song_id}) do
    current_user = conn.assigns[:current_user]

    with song <- Musics.get_song!(song_id) do
      opinions = Opinions.list(song)

      render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end

  def create(conn, %{"kind" => kind, "song_id" => song_id}) do
    current_user = conn.assigns[:current_user]

    with song <- Musics.get_song!(song_id),
         :ok <- Opinions.can?(current_user, :create, song),
         {:ok, _} <- Opinions.upsert(current_user, song, kind) do
      opinions = Opinions.list(song)

      conn
      |> put_status(:created)
      |> render("index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    with opinion <- Opinions.get!(id),
         :ok <- Opinions.can?(current_user, :delete, opinion),
         {:ok, opinion} = Opinions.delete(opinion) do
      song = Musics.get_song!(opinion.song_id)
      opinions = Opinions.list(song)
      render(conn, "index.json", song: song, opinions: opinions, current_user: current_user)
    end
  end
end
