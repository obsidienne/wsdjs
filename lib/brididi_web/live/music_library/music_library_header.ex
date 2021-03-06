defmodule BrididiWeb.MusicLibraryHeader do
  use BrididiWeb, :live_component

  defp count_songs() do
    count = Brididi.Musics.count_songs()
    {:ok, formated_count} = Brididi.Cldr.Number.to_string(count)
    formated_count
  end

  defp count_videos() do
    count = Brididi.Musics.count_videos()
    {:ok, formated_count} = Brididi.Cldr.Number.to_string(count)
    formated_count
  end

  defp count_artists() do
    count = Brididi.Musics.count_artists()
    {:ok, formated_count} = Brididi.Cldr.Number.to_string(count)
    formated_count
  end
end
