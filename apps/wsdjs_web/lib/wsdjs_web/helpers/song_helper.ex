defmodule Wsdjs.Web.SongHelper do
  def song_art_alt(%Wsdjs.Musics.Song{artist: artist, title: title}), do: "#{artist} - #{title} song art"

  def song_full_title(%Wsdjs.Musics.Song{artist: artist, title: title}), do: "#{artist}\u000A#{title}"
end
 