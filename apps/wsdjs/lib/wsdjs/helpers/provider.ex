defmodule Wsdjs.Helpers.Provider do
  @moduledoc """
  This module extract the video id of a youtube url exclusively. 
  No vimeo, or dailymotin, or anything else. Only youtube.
  """
  @provider_types [
      {~r/youtu(?:\.be|be\.com)\/(?:.*v(?:\/|=)|(?:.*\/)?)([\w'-]+)/i, :youtube}
  ]

  @doc ~S"""
  Extract from a youtube url the video id.

  ## Examples
      iex> extract("http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo")
      "1p3vcRhsYGo"
      iex> extract(nil)
      nil
  """
  @spec extract(String.t) :: String.t
  def extract(url) when is_nil(url), do: nil

  def extract(url) do
    {re, func} = Enum.find(@provider_types,
                          {nil, :fn_unknown},
                          fn {reg, _} -> String.match?(url, reg) end
                          )
    Kernel.apply(Wsdjs.Helpers.Provider, func, [re, url])
  end

  @doc false
  def fn_unknown(_re, _url), do: nil

  @doc false
  def youtube(re, url) do
    [_, video_id] = Regex.run(re, url)
    video_id
  end
end
