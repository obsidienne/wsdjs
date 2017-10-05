defmodule WsdjsWeb.Api.V1.VideoController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Musics.Video

  action_fallback WsdjsWeb.Api.V1.FallbackController

  def index(conn, %{"song_id" => song_id}) do
    with song <- Musics.get_song!(song_id) do
      comments = Musics.list_videos(song)

      render(conn, "index.json", videos: videos)
    end
  end

  def create(conn, %{"song_id" => song_id, "video" => params}) do
    current_user = conn.assigns[:current_user]

    params = params
    |> Map.put("user_id", current_user.id)
    |> Map.put("song_id", song_id)

    with :ok <- Musics.Policy.can?(current_user, :create_video),
        {:ok, %Video{} = video} <- Musics.create_video(params) do

      conn
      |> put_status(:created)
      |> render("show.json", video: video)
    end
  end
end
