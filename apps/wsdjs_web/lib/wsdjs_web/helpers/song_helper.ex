defmodule Wsdjs.Web.SongHelper do
  @moduledoc """
  This modules contains all helpers for a %Song{}. 
  """
  alias Wsdjs.Musics.Song

  def song_art_alt(%Song{artist: artist, title: title}), do: "#{artist} - #{title} song art"

  def song_full_title(%Song{artist: artist, title: title}), do: "#{artist}\u000A#{title}"

  def url_for_provider(%Song{video_id: id}) when is_binary(id), do: "http://youtu.be/#{id}"
  def url_for_provider(%Song{url: url}) when is_binary(url), do: url  
  def url_for_provider(_), do: "#"
end
 