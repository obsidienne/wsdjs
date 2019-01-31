defmodule WsdjsWeb.SongActionsController do
  @moduledoc false

  use WsdjsWeb, :controller

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
      render(
        conn,
        "index.html",
        song: song
      )
    end
  end
end
