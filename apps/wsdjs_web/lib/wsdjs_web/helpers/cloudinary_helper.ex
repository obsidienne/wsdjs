defmodule WsdjsWeb.CloudinaryHelper do
  @moduledoc """
  This modules contains all helpers in connection with Cloudinary.
  Notably the html tag and url helpers.
  """
  alias Wsdjs.Musics.Art
  alias Wsdjs.Accounts.Avatar
  alias Wsdjs.Charts.Top

  @art_root_url "//res.cloudinary.com/don2kwaju/image/upload/c_crop,g_custom/w_auto/q_auto,f_auto,dpr_auto/fl_immutable_cache/"
  @art_blured_root_url "//res.cloudinary.com/don2kwaju/image/upload/c_crop,g_custom/w_900,o_30/f_auto,q_auto,dpr_auto/fl_immutable_cache/"
  @art_missing_url "//res.cloudinary.com/don2kwaju/image/upload/fl_immutable_cache/v1449164620/wsdjs/missing_cover.jpg"

  def art_url(%Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @art_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def art_url(_), do: @art_missing_url
  def art_url, do: @art_missing_url

  def art_url_blured(%Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @art_blured_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def art_url_blured(nil), do: @art_missing_url

  @avatar_root_url "//res.cloudinary.com/don2kwaju/image/upload/c_crop,g_custom/w_auto/q_auto,f_auto,dpr_auto/fl_immutable_cache/"
  @avatar_missing_url "//res.cloudinary.com/don2kwaju/image/upload/w_400/fl_immutable_cache/wsdjs/missing_avatar.jpg"
  @avatar_base_url "//res.cloudinary.com/don2kwaju/image/upload/c_crop,g_custom/q_auto,f_auto,dpr_auto/fl_immutable_cache/"

  def avatar_url_with_resolution(%Avatar{cld_id: cld_id, version: version}, resolution) when is_binary(cld_id) do      
    @avatar_base_url <> "w_#{resolution},h_#{resolution}/" <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_url(%Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @avatar_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_url(_), do: @avatar_missing_url
  def avatar_url, do: @avatar_missing_url

  def top_art(%Top{status: "voting"}) do
    "http://res.cloudinary.com/don2kwaju/image/upload/c_scale,w_400/wsdjs/worldswingdjs_single_flat.jpg"
  end

  def top_art(%Top{status: "published"} = top) do
    "http://res.cloudinary.com/don2kwaju/image/upload/c_scale,w_400/"
    <> "l_covers:#{top_rank_art(top, 1)},w_100,x_250,y_-150/"
    <> "l_covers:#{top_rank_art(top, 2)},w_100,x_200,y_-50/"
    <> "l_covers:#{top_rank_art(top, 3)},w_100,x_200,y_50/"
    <> "l_covers:#{top_rank_art(top, 4)},w_100,x_200,y_150/"
    <> "l_covers:#{top_rank_art(top, 5)},w_100,x_-200,y_250/"
    <> "l_covers:#{top_rank_art(top, 6)},w_100,x_-100,y_200/"
    <> "l_covers:#{top_rank_art(top, 7)},w_100,y_200/"
    <> "l_covers:#{top_rank_art(top, 8)},w_100,x_100,y_200/"
    <> "l_covers:#{top_rank_art(top, 9)},w_100,x_200,y_200/"
    <> top_rank_art(top, 0)
  end

  defp top_rank_art(top, 0) do
    rank = Enum.at(top.ranks, 0)
    art = rank.song.art
    "v#{art.version}/#{art.cld_id}.jpg"
  end

  defp top_rank_art(top, i) do
    rank = Enum.at(top.ranks, i)
    art = rank.song.art
    [_ | tail] = String.split(art.cld_id, "/")
    tail
  end
end
