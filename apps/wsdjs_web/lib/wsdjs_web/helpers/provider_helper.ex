defmodule Wsdjs.Web.ProviderHelper do
  def url_for_provider(url) when is_nil(url), do: "#"
  def url_for_provider(url) when is_binary(url), do: url  
  def url_for_provider(%{provider_type: "unknow", url: url}), do: url
  def url_for_provider(%{provider_type: "youtube", provider_id: video_id}), do: "http://youtu.be/#{video_id}"

  def url_for_provider(%Wsdjs.Musics.Song{} = song) do
    if Enum.count(song.providers) > 0 do
      url_for_provider(Enum.at(song.providers, 0))
    else
      url_for_provider(song.url)
    end
  end
end
