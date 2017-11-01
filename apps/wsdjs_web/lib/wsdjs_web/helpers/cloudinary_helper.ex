defmodule WsdjsWeb.CloudinaryHelper do
  @moduledoc """
  This modules contains all helpers in connection with Cloudinary.
  Notably the html tag and url helpers.
  """

  @cld "//res.cloudinary.com/don2kwaju/image/upload/"
  @cld_https "https://res.cloudinary.com/don2kwaju/image/upload/"

  ###############################################
  #
  # SONG ART
  #
  ###############################################
  alias Wsdjs.Musics.Art

  @art_root_url "c_crop,g_custom/w_auto/q_auto,f_auto,dpr_auto/fl_immutable_cache/"
  @art_blured_root_url "c_crop,g_custom/w_900,o_30/f_auto,q_auto,dpr_auto/fl_immutable_cache/"
  @art_missing "fl_immutable_cache/v1449164620/wsdjs/missing_cover.jpg"

  def art_urls(%Art{cld_id: cld_id, version: version}) do
    [50, 100, 200, 300, 400]
    |> Enum.map(fn(x) ->
      [
        width: x,
        url: @cld <> "c_crop,g_custom/#{x}/q_auto,f_auto/fl_immutable_cache/" <> "v#{version}/#{cld_id}.jpg"
      ]
    end)
  end

  def art_url(%Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @cld <> @art_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def art_url(_), do: @cld <> @art_missing
  def art_url, do: @cld <> @art_missing

  def art_url_blured(%Art{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @cld <> @art_blured_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def art_url_blured(nil), do: @cld <> @art_missing

  def art_srcset(%Art{cld_id: cld_id, version: version}) do
    
  end

  def art_srcset(nil) do
    
  end

  ###############################################
  #
  # AVATAR
  #
  ###############################################
  alias Wsdjs.Accounts.Avatar

  @avatar_root_url "c_crop,g_custom/w_auto/q_auto,f_auto,dpr_auto/fl_immutable_cache/"
  @avatar_missing_url "w_400/fl_immutable_cache/wsdjs/missing_avatar.jpg"
  @avatar_base_url "c_crop,g_custom/q_auto,f_auto,dpr_auto/fl_immutable_cache/"

  def avatar_url_with_resolution(%Avatar{cld_id: cld_id, version: version}, resolution) when is_binary(cld_id) do
    @cld <> @avatar_base_url <> "w_#{resolution},h_#{resolution}/" <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_url_with_resolution(nil, resolution), do: @cld <> @avatar_missing_url
  def avatar_url(%Avatar{cld_id: cld_id, version: version}) when is_binary(cld_id) do
    @cld <> @avatar_root_url <> "v#{version}/" <> "#{cld_id}.jpg"
  end
  def avatar_url(_), do: @cld <> @avatar_missing_url
  def avatar_url, do: @cld <> @avatar_missing_url

  ###############################################
  #
  # TOP
  #
  ###############################################
  alias Wsdjs.Charts.Top
  
  @doc """
  Retrieve the image URL corresping to a top in voting status
  """
  def top_art(%Top{status: "voting"}) do
    @cld_https <> "c_scale,w_400/wsdjs/worldswingdjs_single_flat.jpg"
  end

  @doc """
  Retrieve the image URL corresping to a top in published status. 
  It creates a sprite of the 10 first ranked song.
  """
  def top_art(%Top{status: "published"} = top) do
    @cld_https <> "c_scale,w_400/"
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
