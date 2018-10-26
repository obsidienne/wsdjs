defmodule WsdjsApi.V1.VideoView do
  use WsdjsApi, :view
  alias WsdjsApi.V1.VideoView

  def render("index.json", %{videos: videos}) do
    %{
      data: render_many(videos, VideoView, "video.json")
    }
  end

  def render("show.json", %{video: video}) do
    %{
      data: render_one(video, VideoView, "video.json")
    }
  end

  def render("video.json", %{video: video}) do
    v = %{
      id: video.id,
      url: video.url,
      title: video.title,
      event: video.event,
      video_id: video.video_id
    }

    if is_nil(video.published_at) do
      v
    else
      Map.put(
        v,
        :published_at,
        Timex.format!(Timex.to_datetime(video.published_at), "%d %b %Y", :strftime)
      )
    end
  end
end
