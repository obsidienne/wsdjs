defmodule Attachments do
  @moduledoc """
  Documentation for Attachments.
  """

  @base_url ~S(https://res.cloudinary.com/)
  @cloud_name ~S(don2kwaju)
  @cld_https "https://res.cloudinary.com/don2kwaju/image/upload/"
  @cld_youtube "https://res.cloudinary.com/don2kwaju/image/youtube/"
  @dpr_multiple [1, 2, 3]

  def process_url(url), do: "#{@base_url}/#{@cloud_name}/#{url}"
  ###############################################
  #
  # VIDEO THUMBNAIL
  #
  ###############################################
  def thumbnail_url(%{video_id: video_id, provider: "youtube"}, resolution)
      when is_integer(resolution) do
    @cld_youtube <> "c_fit,f_auto,w_#{resolution},q_auto/fl_immutable_cache/" <> "#{video_id}.jpg"
  end

  def thumbnail_url(%{provider: "facebook"}, resolution) when is_integer(resolution) do
    @cld_https <> "c_fit,f_auto,w_#{resolution},q_auto/fl_immutable_cache/v1/wsdjs/facebook.jpg"
  end

  def thumbnail_url(%{}, resolution) when is_integer(resolution) do
    @cld_https <>
      "c_fit,f_auto,w_#{resolution},q_auto/fl_immutable_cache/v1/wsdjs/missing_cover.jpg"
  end

  def thumbnail_srcset(%{} = video, base) when is_integer(base) do
    resolutions = Enum.map(@dpr_multiple, &(base * &1))

    resolutions
    |> Enum.map(fn r -> "#{thumbnail_url(video, r)} #{r}w" end)
    |> Enum.join(", ")
  end

  ###############################################
  #
  # SONG ART
  #
  ###############################################
  def art_url(%{cld_id: cld_id, version: version}, resolution) when is_integer(resolution) do
    @cld_https <>
      "c_crop,g_custom/c_fit,f_auto,h_#{resolution},q_auto,w_#{resolution}/fl_immutable_cache/" <>
      "v#{version}/#{cld_id}.jpg"
  end

  def art_url(nil, resolution),
    do: art_url(%{cld_id: "wsdjs/missing_cover", version: "1"}, resolution)

  def art_srcset(%{} = art, base) when is_integer(base) do
    resolutions = Enum.map(@dpr_multiple, &(base * &1))

    resolutions
    |> Enum.map(fn r -> "#{art_url(art, r)} #{r}w" end)
    |> Enum.join(", ")
  end

  def art_srcset(nil, base),
    do: art_srcset(%{cld_id: "wsdjs/missing_cover", version: "1"}, base)

  def art_url_blured(%{cld_id: cld_id, version: version}, resolution)
      when is_integer(resolution) do
    @cld_https <>
      "c_crop,g_custom/c_fit,f_auto,o_30,q_auto,w_#{resolution}/fl_immutable_cache/" <>
      "v#{version}/#{cld_id}.jpg"
  end

  def art_url_blured(nil, resolution),
    do: art_url_blured(%{cld_id: "wsdjs/missing_cover", version: "1"}, resolution)

  ###############################################
  #
  # AVATAR
  #
  ###############################################
  def avatar_url(%{cld_id: cld_id, version: version}, resolution)
      when is_integer(resolution) do
    @cld_https <>
      "c_crop,g_custom/c_fit,f_auto,h_#{resolution},q_auto,w_#{resolution}/fl_immutable_cache/" <>
      "v#{version}/#{cld_id}.jpg"
  end

  def avatar_url(_, resolution),
    do: avatar_url(%{cld_id: "wsdjs/missing_avatar", version: "1"}, resolution)

  def avatar_srcset(%{} = art, base) when is_integer(base) do
    resolutions = Enum.map(@dpr_multiple, &(base * &1))

    resolutions
    |> Enum.map(fn r -> "#{avatar_url(art, r)} #{r}w" end)
    |> Enum.join(", ")
  end

  def avatar_srcset(_, base),
    do: avatar_srcset(%{cld_id: "wsdjs/missing_avatar", version: "1"}, base)
end
