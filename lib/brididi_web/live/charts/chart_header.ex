defmodule BrididiWeb.ChartHeader do
  use BrididiWeb, :live_component

  defp count_tops() do
    count = Brididi.Charts.count_charts()
    {:ok, formated_count} = Brididi.Cldr.Number.to_string(count)
    formated_count
  end

  defp count_djs() do
    count = Brididi.Charts.count_djs()
    {:ok, formated_count} = Brididi.Cldr.Number.to_string(count)
    formated_count
  end
end
