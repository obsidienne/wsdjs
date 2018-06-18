defmodule WsdjsWeb.RadioController do
  @moduledoc false

  use WsdjsWeb, :controller
  use WsdjsWeb.Controller

  def show(conn, _params, _current_user) do
    songs = WsdjsApi.Service.RadioSrv.streamed(conn)

    case Poison.decode(songs) do
      {:ok, songs} ->
        render(conn, "show.html", songs: songs)

      {:error, _, _} ->
        render(conn, "show.html", songs: :empty)
    end
  end
end
