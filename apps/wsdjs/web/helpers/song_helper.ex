defmodule Wsdjs.SongHelper do
  @base_url "http://res.cloudinary.com/don2kwaju/image/upload/"
  @small_format "ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/"
  @missing_song_art "v1/wsdjs/missing_cover.jpg"

  def song_art_href(%Wcsp.AlbumArt{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> @small_format <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def song_art_href(nil), do: @base_url <> @small_format <> @missing_song_art

  def song_art_alt(%Wcsp.Song{artist: artist, title: title}), do: "#{artist} - #{title} song art"

  def song_full_title(%Wcsp.Song{artist: artist, title: title}), do: "#{artist}\u000A#{title}"
end
