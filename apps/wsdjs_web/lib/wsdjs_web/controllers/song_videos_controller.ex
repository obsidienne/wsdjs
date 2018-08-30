defmodule WsdjsWeb.SongVideosController do
  @moduledoc false

  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  alias Wsdjs.Attachments
  alias Wsdjs.Attachments.Video
  alias Wsdjs.Musics

  action_fallback(WsdjsWeb.FallbackController)

  @spec index(Plug.Conn.t(), any(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def index(conn, %{"song_id" => song_id}, current_user) do
    song = Musics.get_song!(song_id)

    with :ok <- Musics.Policy.can?(current_user, :show, song) do
      videos = Attachments.list_videos(song)
      video_changeset = Attachments.change_video(%Video{})

      render(
        conn,
        "index.html",
        song: song,
        videos: videos,
        video_changeset: video_changeset
      )
    end
  end
end
