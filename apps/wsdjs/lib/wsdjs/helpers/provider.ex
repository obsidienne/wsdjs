defmodule Wsdjs.Helpers.Provider do
  @moduledoc """
  This module extract the video id of a youtube url exclusively. 
  No vimeo, or dailymotin, or anything else. Only youtube.
  """
  @provider_types [
      {~r/youtu(?:\.be|be\.com)\/(?:.*v(?:\/|=)|(?:.*\/)?)([\w'-]+)/i, :youtube}
  ]

  def extract(url) when is_nil(url), do: nil

  def extract(url) do
    {re, func} = Enum.find(@provider_types,
                          {nil, :fn_unknown},
                          fn {reg, _} -> String.match?(url, reg) end
                          )
    Kernel.apply(Wsdjs.Helpers.Provider, func, [re, url])
  end

  def fn_unknown(_re, _url), do: nil

  @doc ~S"""
    Should match the following youtube URLs

    ## Examples

      iex> re = ~r/youtu(?:\.be|be\.com)\/(?:.*v(?:\/|=)|(?:.*\/)?)([\w'-]+)/i
      iex> youtube(re, "http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo")
      "1p3vcRhsYGo"
      iex> youtube(re, "http://www.youtube.com/watch?v=cKZDdG9FTKY&feature=channel")
      "cKZDdG9FTKY"
      iex> youtube(re, "http://www.youtube.com/watch?v=yZ-K7nCVnBI&playnext_from=TL&videos=osPknwzXEas&feature=sub")
      "yZ-K7nCVnBI"
      iex> youtube(re, "http://www.youtube.com/ytscreeningroom?v=NRHVzbJVx8I")
      "NRHVzbJVx8I"
      iex> youtube(re, "http://www.youtube.com/user/SilkRoadTheatre#p/a/u/2/6dwqZw0j_jY")
      "6dwqZw0j_jY"
      iex> youtube(re, "http://youtu.be/6dwqZw0j_jY")
      "6dwqZw0j_jY"
      iex> youtube(re, "http://www.youtube.com/watch?v=6dwqZw0j_jY&feature=youtu.be")
      "6dwqZw0j_jY"
      iex> youtube(re, "http://youtu.be/afa-5HQHiAs")
      "afa-5HQHiAs"
      iex> youtube(re, "http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo?rel=0")
      "1p3vcRhsYGo"
      iex> youtube(re, "http://www.youtube.com/watch?v=cKZDdG9FTKY&feature=channel")
      "cKZDdG9FTKY"
      iex> youtube(re, "http://www.youtube.com/watch?v=yZ-K7nCVnBI&playnext_from=TL&videos=osPknwzXEas&feature=sub")
      "yZ-K7nCVnBI"
      iex> youtube(re, "http://www.youtube.com/ytscreeningroom?v=NRHVzbJVx8I")
      "NRHVzbJVx8I"
      iex> youtube(re, "http://www.youtube.com/embed/nas1rJpm7wY?rel=0")
      "nas1rJpm7wY"
      iex> youtube(re, "http://www.youtube.com/watch?v=peFZbP64dsU")
      "peFZbP64dsU"
  """
  def youtube(re, url) do
    [_, video_id] = Regex.run(re, url)
    video_id
  end
end
