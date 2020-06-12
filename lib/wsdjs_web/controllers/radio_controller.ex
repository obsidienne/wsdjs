defmodule WsdjsWeb.RadioController do
  @moduledoc false

  use WsdjsWeb, :controller

  @spec show(Plug.Conn.t(), any()) :: Plug.Conn.t()
  def show(conn, _params) do
    songs = WsdjsWeb.Service.RadioSrv.streamed(conn)

    case Jason.decode(songs) do
      {:ok, songs} ->
        render(conn, "show.html", songs: songs)

      {:error, _} ->
        render(conn, "show.html", songs: :empty)
    end
  end
end
