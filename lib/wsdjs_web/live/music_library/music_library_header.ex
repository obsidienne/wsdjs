defmodule WsdjsWeb.MusicLibraryHeader do
  use WsdjsWeb, :live_component

  defp count_songs() do
    count = Wsdjs.Musics.count_songs()
    {:ok, formated_count} = Wsdjs.Cldr.Number.to_string(count)
    formated_count
  end

  defp count_videos() do
    count = Wsdjs.Attachments.count_videos()
    {:ok, formated_count} = Wsdjs.Cldr.Number.to_string(count)
    formated_count
  end

  defp count_artists() do
    count = Wsdjs.Musics.count_artists()
    {:ok, formated_count} = Wsdjs.Cldr.Number.to_string(count)
    formated_count
  end


end
