defmodule Wsdjs.Attachments.Provider do
  @moduledoc """
  This module extract the video id of a youtube url exclusively. 
  No vimeo, or dailymotin, or anything else. Only youtube.
  """
  @provider_types [
    {~r/youtu(?:\.be|be\.com)\/(?:.*v(?:\/|=)|(?:.*\/)?)([\w'-]+)/i, :youtube},
    {~r/.*facebook\.com\/(.+\/videos\/\w+)/i, :facebook}
  ]

  @doc ~S"""
  Extract from a youtube url the video id.

  ## Examples
      iex> extract(nil)
      nil
      iex> type(nil)
      nil
      iex> extract("http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo")
      "1p3vcRhsYGo"
      iex> type("http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo")
      "youtube"
      iex> extract("https://www.facebook.com/thibault.ramirez.1/videos/1197018457068034/")
      "thibault.ramirez.1/videos/1197018457068034/"
      iex> type("https://www.facebook.com/thibault.ramirez.1/videos/1197018457068034/")
      "facebook"
  """
  @spec extract(String.t) :: String.t
  def extract(url) when is_nil(url), do: nil
  def type(url) when is_nil(url), do: nil

  def extract(url) do
    {re, func} = Enum.find(@provider_types,
                          {nil, :unknown},
                          fn {reg, _} -> String.match?(url, reg) end
                          )
    Kernel.apply(Wsdjs.Attachments.Provider, func, [re, url])
  end

  def type(url) do
    {_, func} = Enum.find(@provider_types,
                          {nil, :unknown},
                          fn {reg, _} -> String.match?(url, reg) end
                          )
    Atom.to_string(func)
  end

  @doc false
  def unknown(_re, _url), do: "unknown"

  @doc false
  def youtube(re, url) do
    [_, video_id] = Regex.run(re, url)
    video_id
  end

  def facebook(re, url) do
    [_, video_id] = Regex.run(re, url)
    video_id
  end
end
