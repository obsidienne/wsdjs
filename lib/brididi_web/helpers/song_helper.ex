defmodule BrididiWeb.SongHelper do
  @moduledoc """
  This modules contains all helpers for a %Song{}.
  """
  alias Brididi.Musics.Song

  def url_for_provider(%Song{video_id: id}) when is_binary(id),
    do: "https://www.youtube.com/watch?v=#{id}"

  def url_for_provider(%Song{url: url}) when is_binary(url), do: url
  def url_for_provider(_), do: "#"
end
