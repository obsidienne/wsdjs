defmodule Wsdjs.ProviderTest do
  @moduledoc false

  use Wsdjs.DataCase
  doctest Wsdjs.Helpers.Provider, import: true

  @youtube_urls [
      {"http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo", "1p3vcRhsYGo"},
      {"http://www.youtube.com/watch?v=cKZDdG9FTKY&feature=channel", "cKZDdG9FTKY"},
      {"http://www.youtube.com/watch?v=yZ-K7nCVnBI&playnext_from=TL&videos=osPknwzXEas&feature=sub", "yZ-K7nCVnBI"},
      {"http://www.youtube.com/ytscreeningroom?v=NRHVzbJVx8I", "NRHVzbJVx8I"},
      {"http://www.youtube.com/user/SilkRoadTheatre#p/a/u/2/6dwqZw0j_jY", "6dwqZw0j_jY"},
      {"http://youtu.be/6dwqZw0j_jY", "6dwqZw0j_jY"},
      {"http://www.youtube.com/watch?v=6dwqZw0j_jY&feature=youtu.be", "6dwqZw0j_jY"},
      {"http://youtu.be/afa-5HQHiAs", "afa-5HQHiAs"},
      {"http://www.youtube.com/user/Scobleizer#p/u/1/1p3vcRhsYGo?rel=0", "1p3vcRhsYGo"},
      {"http://www.youtube.com/watch?v=cKZDdG9FTKY&feature=channel", "cKZDdG9FTKY"},
      {"http://www.youtube.com/watch?v=yZ-K7nCVnBI&playnext_from=TL&videos=osPknwzXEas&feature=sub", "yZ-K7nCVnBI"},
      {"http://www.youtube.com/ytscreeningroom?v=NRHVzbJVx8I", "NRHVzbJVx8I"},
      {"http://www.youtube.com/embed/nas1rJpm7wY?rel=0", "nas1rJpm7wY"},
      {"http://www.youtube.com/watch?v=peFZbP64dsU", "peFZbP64dsU"}
  ]

  test "youtube urls" do
    Enum.each(@youtube_urls, fn {url, video_id} -> assert Wsdjs.Helpers.Provider.extract(url) == video_id end)
  end
end
