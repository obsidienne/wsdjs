defmodule WsdjsWeb.CloudinaryHelper do
  @moduledoc """
  This modules contains all helpers in connection with Cloudinary.
  Notably the html tag and url helpers.
  """

  @cld_https "https://res.cloudinary.com/don2kwaju/image/upload/"

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
    @cld_https <>
      "c_scale,w_400/" <>
      "l_covers:#{top_rank_art(top, 1)},w_100,x_250,y_-150/" <>
      "l_covers:#{top_rank_art(top, 2)},w_100,x_200,y_-50/" <>
      "l_covers:#{top_rank_art(top, 3)},w_100,x_200,y_50/" <>
      "l_covers:#{top_rank_art(top, 4)},w_100,x_200,y_150/" <>
      "l_covers:#{top_rank_art(top, 5)},w_100,x_-200,y_250/" <>
      "l_covers:#{top_rank_art(top, 6)},w_100,x_-100,y_200/" <>
      "l_covers:#{top_rank_art(top, 7)},w_100,y_200/" <>
      "l_covers:#{top_rank_art(top, 8)},w_100,x_100,y_200/" <>
      "l_covers:#{top_rank_art(top, 9)},w_100,x_200,y_200/" <> top_rank_art(top, 0)
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
