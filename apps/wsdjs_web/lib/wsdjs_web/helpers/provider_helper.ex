defmodule Wsdjs.Web.ProviderHelper do
  def url_for_provider(%{provider_type: "unknow", url: url}), do: url
  def url_for_provider(%{provider_type: "youtube", provider_id: video_id}), do: "http://youtu.be/#{video_id}"
end