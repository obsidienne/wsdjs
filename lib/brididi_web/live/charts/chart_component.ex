defmodule BrididiWeb.ChartComponent do
  use BrididiWeb, :live_component

  def count_dj(songs) do
    songs
    |> Enum.map(fn x -> x.user_id end)
    |> Enum.uniq()
    |> Enum.count()
  end
end
