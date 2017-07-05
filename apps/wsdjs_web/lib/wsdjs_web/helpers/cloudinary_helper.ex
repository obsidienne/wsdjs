defmodule Wsdjs.Web.CloudinaryHelper do
  @base_url "//res.cloudinary.com/don2kwaju/image/upload/w_auto/c_crop,g_custom/"
  @base_url_blured "//res.cloudinary.com/don2kwaju/image/upload/w_auto,h_350,c_crop,g_custom/e_blur:300/o_30/"
  @missing_song_art "//res.cloudinary.com/don2kwaju/image/upload/v1449164620/wsdjs/missing_cover.jpg"

  def art_url(%Wsdjs.Musics.Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def art_url(nil), do: @missing_song_art

  def art_url_blured(%Wsdjs.Musics.Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url_blured <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def art_url_blured(nil), do: @missing_song_art


  def art_url_default(), do: @missing_song_art


  @avatar_base_url "//res.cloudinary.com/don2kwaju/image/upload/w_auto/c_crop,g_custom/"
  @missing_avatar "//res.cloudinary.com/don2kwaju/image/upload/v1450094305/wsdjs/missing_avatar.jpg"

  def avatar_url(%Wsdjs.Accounts.Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @avatar_base_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_url(_), do: @missing_avatar
  def avatar_url_default(), do: @missing_avatar
end
