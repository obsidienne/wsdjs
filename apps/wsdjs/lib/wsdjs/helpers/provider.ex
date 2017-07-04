defmodule Wsdjs.Helpers.Provider do
  @provider_types [
      {~r/youtu(?:\.be|be\.com)\/(?:.*v(?:\/|=)|(?:.*\/)?)([\w'-]+)/i, :youtube_01}
  ]

  def extract(url) do
    {re, func} = Enum.find(@provider_types,
                          {nil, :fn_unknown},
                          fn {reg, _} -> String.match?(url, reg) end
                          )
    Kernel.apply(Wsdjs.Helpers.Provider, func, [re, url])
  end


  @doc """
    Should match the following URL

    http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo
    http://www.youtube.com/watch?v=cKZDdG9FTKY&feature=channel
    http://www.youtube.com/watch?v=yZ-K7nCVnBI&playnext_from=TL&videos=osPknwzXEas&feature=sub
    http://www.youtube.com/ytscreeningroom?v=NRHVzbJVx8I
    http://www.youtube.com/user/SilkRoadTheatre#p/a/u/2/6dwqZw0j_jY
    http://youtu.be/6dwqZw0j_jY
    http://www.youtube.com/watch?v=6dwqZw0j_jY&feature=youtu.be
    http://youtu.be/afa-5HQHiAs
    http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo?rel=0
    http://www.youtube.com/watch?v=cKZDdG9FTKY&feature=channel
    http://www.youtube.com/watch?v=yZ-K7nCVnBI&playnext_from=TL&videos=osPknwzXEas&feature=sub
    http://www.youtube.com/ytscreeningroom?v=NRHVzbJVx8I
    http://www.youtube.com/embed/nas1rJpm7wY?rel=0
    http://www.youtube.com/watch?v=peFZbP64dsU
  """
  def youtube_01(re, url) do
    [_, video_id] = Regex.run(re, url)
    %{
      url: url,
      provider_type: "youtube",
      provider_id: video_id
    }
  end
end
