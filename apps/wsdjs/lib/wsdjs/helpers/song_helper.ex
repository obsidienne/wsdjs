defmodule Wsdjs.SongHelper do
  @base_url "http://res.cloudinary.com/don2kwaju/image/upload/"
  @auto_format "w_auto/c_scale/"
  @missing_song_art "dpr_auto/f_auto,q_auto/v1/wsdjs/missing_cover.jpg"

  def song_art_href(%Wcsp.AlbumArt{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> @auto_format <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def song_art_href(nil), do: ""

  def song_art_href_default(), do: @base_url <> @missing_song_art

  def song_art_alt(%Wcsp.Song{artist: artist, title: title}), do: "#{artist} - #{title} song art"

  def song_full_title(%Wcsp.Song{artist: artist, title: title}), do: "#{artist}\u000A#{title}"
end
