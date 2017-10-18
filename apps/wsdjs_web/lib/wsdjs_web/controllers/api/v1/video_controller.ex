defmodule WsdjsWeb.Api.V1.VideoController do
  @moduledoc false
  use WsdjsWeb, :controller

  alias Wsdjs.Musics
  alias Wsdjs.Attachments
  alias Wsdjs.Attachments.Video

  action_fallback WsdjsWeb.Api.V1.FallbackController

  def index(conn, %{"song_id" => song_id}) do
    with song <- Musics.get_song!(song_id) do
      videos = Attachments.list_videos(song)

      render(conn, "index.json", videos: videos)
    end
  end

  def create(conn, %{"song_id" => song_id, "video" => params}) do
    current_user = conn.assigns[:current_user]

    params = params
    |> Map.put("user_id", current_user.id)
    |> Map.put("song_id", song_id)

    with :ok <- Attachments.Policy.can?(current_user, :create_video),
        {:ok, %Video{} = video} <- Attachments.create_video(params) do

      conn
      |> put_status(:created)
      |> render("show.json", video: video)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = conn.assigns[:current_user]

    video = Attachments.get_video!(id)
    with :ok <- Attachments.Policy.can?(current_user, :delete, video),
         {:ok, %Video{}} <- Attachments.delete_video(video) do
      send_resp(conn, :no_content, "")
    end
  end
end
