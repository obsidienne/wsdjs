defmodule WsdjsApi.VideoController do
  @moduledoc false
  use WsdjsApi, :controller

  alias Wsdjs.Attachments
  alias Wsdjs.Attachments.Videos.Video
  alias Wsdjs.Musics

  action_fallback(WsdjsApi.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, %{"song_id" => song_id}, _current_user) do
    with song <- Musics.Songs.get_song!(song_id) do
      videos = Attachments.list_videos(song)

      render(conn, "index.json", videos: videos)
    end
  end

  def create(conn, %{"song_id" => song_id, "video" => params}, current_user) do
    params =
      params
      |> Map.put("user_id", current_user.id)
      |> Map.put("song_id", song_id)

    with :ok <- Attachments.Policy.can?(current_user, :create_video),
         {:ok, %Video{} = video} <- Attachments.create_video(params) do
      conn
      |> put_status(:created)
      |> render("show.json", video: video)
    end
  end

  def delete(conn, %{"id" => id}, current_user) do
    video = Attachments.get_video!(id)

    with :ok <- Attachments.Policy.can?(current_user, :delete, video),
         {:ok, %Video{}} <- Attachments.delete_video(video) do
      send_resp(conn, :no_content, "")
    end
  end
end
