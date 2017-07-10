defmodule Wsdjs.Web.ProviderHelper do
  alias Wsdjs.Musics.Song

  def url_for_provider(%Song{video_id: id}) when is_binary(id), do: "http://youtu.be/#{id}"
  def url_for_provider(%Song{url: url}) when is_binary(url), do: url  
  def url_for_provider(_), do: "#"
end
