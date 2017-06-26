defmodule Wsdjs.Web.SongHelper do
  @base_url "//res.cloudinary.com/don2kwaju/image/upload/w_auto/c_crop,g_custom/"
  @base_url_blured "//res.cloudinary.com/don2kwaju/image/upload/w_auto,h_350,c_crop,g_custom/e_blur:300/o_30/"
  @missing_song_art "//res.cloudinary.com/don2kwaju/image/upload/v1449164620/wsdjs/missing_cover.jpg"

  def song_art_href(%Wsdjs.Musics.Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def song_art_href(nil), do: @missing_song_art

  def song_art_href_blured(%Wsdjs.Musics.Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url_blured <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def song_art_href_blured(nil), do: @missing_song_art


  def song_art_href_default(), do: @missing_song_art


  def song_art_alt(%Wsdjs.Musics.Song{artist: artist, title: title}), do: "#{artist} - #{title} song art"

  def song_full_title(%Wsdjs.Musics.Song{artist: artist, title: title}), do: "#{artist}\u000A#{title}"

  def can_edit_song?(current_user, song) do
    song.user.id == current_user.id || current_user.admin 
  end
  
end
