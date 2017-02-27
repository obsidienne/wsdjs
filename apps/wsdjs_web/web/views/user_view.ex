defmodule WsdjsWeb.UserView do
  require Logger
  use WsdjsWeb.Web, :view

  @base_url "http://res.cloudinary.com/don2kwaju/image/upload/"
  @small_format "ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/"
  @missing_song_art "v1/wsdjs/missing_cover.jpg"

  def href_user_avatar(%{cld_id: cld_id, version: version})when is_binary(cld_id) do
    @base_url <> @small_format <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def href_user_avatar(_), do: @base_url <> @small_format <> @missing_song_art
  def user_avatar_alt(user), do: "#{user.name}"

end
