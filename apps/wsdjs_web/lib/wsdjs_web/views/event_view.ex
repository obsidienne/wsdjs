defmodule WsdjsWeb.EventView do
  use WsdjsWeb, :view

  def lat(%Geo.Point{coordinates: {_, lat}}), do: lat
  def lat(nil), do: ""
  def lon(%Geo.Point{coordinates: {lon, _}}), do: lon
  def lon(nil), do: ""
end
