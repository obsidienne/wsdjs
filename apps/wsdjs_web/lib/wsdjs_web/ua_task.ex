defmodule Release.Tasks.Ua do
  def download do
    {:ok, _} = Application.ensure_all_started(:wsdjs_web)

    UAInspector.Downloader.download()
    UAInspector.reload()
  end
end
