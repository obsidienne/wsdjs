defmodule WsdjsApi.NowPlayingController do
  @moduledoc false
  use WsdjsApi, :controller

  require Logger

  def index(conn, _params) do
    songs = ConCache.get(:wsdjs_cache, "streamed_songs")
    json(conn, songs)
  end
end
