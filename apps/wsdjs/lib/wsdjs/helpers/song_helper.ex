defmodule Wsdjs.SongHelper do
  @base_url "https://res.cloudinary.com/don2kwaju/image/upload/w_auto/c_scale/"
  @base_url_blured "https://res.cloudinary.com/don2kwaju/image/upload/w_auto,c_fill,h_350,g_face/e_blur:800/o_30/"
  @missing_song_art "http://res.cloudinary.com/don2kwaju/image/upload/v1449164620/wsdjs/missing_cover.jpg"

  def song_art_href(%Wcsp.Musics.Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def song_art_href(nil), do: @missing_song_art

  def song_art_href_blured(%Wcsp.Musics.Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url_blured <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def song_art_href_blured(nil), do: @missing_song_art


  def song_art_href_default(), do: @missing_song_art


  def song_art_alt(%Wcsp.Musics.Song{artist: artist, title: title}), do: "#{artist} - #{title} song art"

  def song_full_title(%Wcsp.Musics.Song{artist: artist, title: title}), do: "#{artist}\u000A#{title}"
end
