defmodule WsdjsWeb.TopView do
  use WsdjsWeb.Web, :view

  @base_url "http://res.cloudinary.com/don2kwaju/image/upload/"
  @small_format "ar_1:1,c_fill,g_auto/w_auto:100:250/dpr_auto/f_auto,q_auto/"
  @missing_song_art "v1/wsdjs/missing_cover.jpg"

  def href_song_art(%{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @base_url <> @small_format <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def href_song_art(_) do
    @base_url <> @small_format <> @missing_song_art
  end

  def song_art_alt(rank) do
    "#{rank.song.artist} - #{rank.song.title} (#{rank.votes + rank.bonus + rank.likes} point)"
  end

  def proposed_by_display_name(%{name: name, djname: djname}) when is_binary(djname) do
    "#{name} (#{djname})"
  end
  def proposed_by_display_name(%{name: name, djname: djname}) do
    name
  end
end
