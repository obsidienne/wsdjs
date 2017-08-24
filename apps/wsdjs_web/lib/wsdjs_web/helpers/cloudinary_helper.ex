defmodule WsdjsWeb.CloudinaryHelper do
  @moduledoc """
  This modules contains all helpers in connection with Cloudinary.
  Notably the html tag and url helpers.
  """
  alias Wsdjs.Musics.Art
  alias Wsdjs.Accounts.Avatar

  @art_root_url "//res.cloudinary.com/don2kwaju/image/upload/w_auto/c_limit,w_400/c_crop,g_custom,q_auto,f_auto/"
  @art_blured_root_url "//res.cloudinary.com/don2kwaju/image/upload/w_400,c_crop,g_custom,f_auto,q_auto/o_30/"
  @art_missing_url "//res.cloudinary.com/don2kwaju/image/upload/v1449164620/wsdjs/missing_cover.jpg"
  
  def art_url(%Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @art_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def art_url(_), do: @art_missing_url
  def art_url, do: @art_missing_url

  def art_url_blured(%Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @art_blured_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def art_url_blured(nil), do: @art_missing_url

  @avatar_root_url "//res.cloudinary.com/don2kwaju/image/upload/w_auto/c_crop,g_custom,q_auto,f_auto/"
  @avatar_missing_url "//res.cloudinary.com/don2kwaju/image/upload/wsdjs/missing_avatar.jpg"

  def avatar_url(%Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @avatar_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_url(_), do: @avatar_missing_url
  def avatar_url, do: @avatar_missing_url
end
