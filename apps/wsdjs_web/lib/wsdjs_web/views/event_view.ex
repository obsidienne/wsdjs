defmodule WsdjsWeb.EventView do
  use WsdjsWeb, :view

  def lat(%Geo.Point{coordinates: {_, lat}}), do: lat
  def lon(%Geo.Point{coordinates: {lon, _}}), do: lon
end
