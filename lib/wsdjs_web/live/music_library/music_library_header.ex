defmodule WsdjsWeb.MusicLibraryHeader do
  use WsdjsWeb, :live_component

  alias Wsdjs.Musics

  defp count_songs() do
    count = Musics.count_songs()
    {:ok, formated_count} = Wsdjs.Cldr.Number.to_string(count)
    formated_count
  end
end
