defmodule WsdjsWeb.SongVideosController do
  @moduledoc false

  use WsdjsWeb, :controller

  alias Wsdjs.Attachments
  alias Wsdjs.Attachments.Videos.Video
  alias Wsdjs.Musics.Song
  alias Wsdjs.Musics.Songs

  action_fallback(WsdjsWeb.FallbackController)

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  @spec index(Plug.Conn.t(), any(), Wsdjs.Accounts.User.t()) ::
          {:error, :unauthorized} | Plug.Conn.t()
  def index(conn, %{"song_id" => song_id}, current_user) do
    song = Songs.get_song!(song_id)

    with :ok <- Songs.can?(current_user, :show, song) do
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

  def new(conn, %{"song_id" => song_id}, current_user) do
    song = Songs.get_song!(song_id)

    with :ok <- Songs.can?(current_user, :create) do
      changeset = Attachments.change_video(%Video{})
      render(conn, "new.html", changeset: changeset, song: song)
    end
  end

  def create(conn, %{"song_id" => song_id, "video" => params}, current_user) do
    song = Songs.get_song!(song_id)

    params =
      params
      |> Map.put("user_id", current_user.id)
      |> Map.put("song_id", song_id)

    with :ok <- Attachments.Policy.can?(current_user, :create_video),
         {:ok, _} <- Attachments.create_video(params) do
      conn
      |> put_flash(:info, "Video created")
      |> redirect(to: Routes.song_song_videos_path(conn, :index, song))
    end
  end
end
