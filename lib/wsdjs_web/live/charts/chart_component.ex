defmodule WsdjsWeb.ChartComponent do
  use WsdjsWeb, :live_component

  def dominante_genre(songs) do
    songs
    |> Enum.sort(&(&1 <= &2))
    |> Enum.group_by(fn x -> x.genre end)
    |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
    |> Enum.sort(fn {_, v1}, {_, v2} -> v1 >= v2 end)
    |> Enum.take(3)
    |> Enum.map(fn {k, v} ->
      {:safe, "<div>#{k} <span class=\"text-gray-800\">(#{v})</span></div>"}
    end)
  end

  def count_dj(songs) do
    songs
    |> Enum.map(fn x -> x.user_id end)
    |> Enum.uniq()
    |> Enum.count()
  end
end
