defmodule Wsdjs.Web.SongHelper do
  def song_art_alt(%Wsdjs.Musics.Song{artist: artist, title: title}), do: "#{artist} - #{title} song art"

  def song_full_title(%Wsdjs.Musics.Song{artist: artist, title: title}), do: "#{artist}\u000A#{title}"

  def can_edit_song?(current_user, song) do
    song.user.id == current_user.id || current_user.admin 
  end
end
