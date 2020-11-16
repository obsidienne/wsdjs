defmodule WsdjsWeb.MusicLibraryHeader do
  use WsdjsWeb, :live_component

  alias Wsdjs.Musics

  defp count_songs(), do: Musics.count_songs()
end
