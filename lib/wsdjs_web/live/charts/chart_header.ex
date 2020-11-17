defmodule WsdjsWeb.ChartHeader do
  use WsdjsWeb, :live_component

  defp count_tops() do
    count = Wsdjs.Charts.count_charts()
    {:ok, formated_count} = Wsdjs.Cldr.Number.to_string(count)
    formated_count
  end

  defp count_djs() do
    count = Wsdjs.Charts.count_djs()
    {:ok, formated_count} = Wsdjs.Cldr.Number.to_string(count)
    formated_count
  end
end
