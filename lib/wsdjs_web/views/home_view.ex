defmodule WsdjsWeb.HomeView do
  use WsdjsWeb, :view

  def group_song_by_month(songs) do
    songs
    |> Enum.group_by(fn song -> month_from_date(song.inserted_at) end)
    |> Enum.sort_by(fn {dt, _} -> Date.to_erl(dt) end, &>=/2)
  end

  def month_from_date(date) do
    {:ok, month} = Date.new(date.year, date.month, 1)
    month
  end
end
