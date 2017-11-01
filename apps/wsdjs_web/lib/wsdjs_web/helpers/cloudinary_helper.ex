defmodule WsdjsWeb.CloudinaryHelper do
  @moduledoc """
  This modules contains all helpers in connection with Cloudinary.
  Notably the html tag and url helpers.
  """

  @cld "//res.cloudinary.com/don2kwaju/image/upload/"
  @cld_https "https://res.cloudinary.com/don2kwaju/image/upload/"
  @dpr_multiple [1, 2, 3]

  ###############################################
  #
  # SONG ART
  #
  ###############################################
  alias Wsdjs.Musics.Art

  def art_url(%Art{cld_id: cld_id, version: version}, resolution) when is_integer(resolution) do
    @cld <> "c_crop,g_custom/c_fit,f_auto,h_#{resolution},q_auto,w_#{resolution}/fl_immutable_cache/" <> "v#{version}/#{cld_id}.jpg"
  end
  def art_url(nil, resolution), do: art_url(%Art{cld_id: "wsdjs/missing_cover.jpg", version: "1"}, resolution)

  def art_srcset(%Art{} = art, base) when is_integer(base) do
    resolutions = Enum.map(@dpr_multiple, &(base * &1))

    resolutions
    |> Enum.map(fn(r) -> "#{art_url(art, r)} #{r}w" end)
    |> Enum.join(", ")
  end
  def art_srcset(nil, base), do: art_srcset(%Art{cld_id: "wsdjs/missing_cover", version: "1"}, base)

  def art_url_blured(%Art{cld_id: cld_id, version: version}, resolution) when is_integer(resolution) do
    @cld <> "c_crop,g_custom/c_fit,f_auto,o_30,q_auto,w_#{resolution}/fl_immutable_cache/" <> "v#{version}/#{cld_id}.jpg"
  end
  def art_url_blured(nil, resolution), do: art_url_blured(%Art{cld_id: "wsdjs/missing_cover", version: "1"}, resolution)


  ###############################################
  #
  # AVATAR
  #
  ###############################################
  alias Wsdjs.Accounts.Avatar

  def avatar_url(%Avatar{cld_id: cld_id, version: version}, resolution) when is_integer(resolution) do
    @cld <> "c_crop,g_custom/c_fit,f_auto,h_#{resolution},q_auto,w_#{resolution}/fl_immutable_cache/" <> "v#{version}/#{cld_id}.jpg"
  end
  def avatar_url(nil, resolution), do: avatar_url(%Avatar{cld_id: "wsdjs/missing_avatar", version: "1"}, resolution)

  def avatar_srcset(%Avatar{} = art, base) when is_integer(base) do
    resolutions = Enum.map(@dpr_multiple, &(base * &1))

    resolutions
    |> Enum.map(fn(r) -> "#{avatar_url(art, r)} #{r}w" end)
    |> Enum.join(", ")
  end
  def avatar_srcset(nil, base), do: avatar_srcset(%Avatar{cld_id: "wsdjs/missing_avatar", version: "1"}, base)

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
