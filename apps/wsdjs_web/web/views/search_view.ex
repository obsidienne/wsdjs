defmodule WsdjsWeb.SearchView do
  use WsdjsWeb.Web, :view

  def proposed_date(dt), do: Ecto.DateTime.to_iso8601(Ecto.DateTime.cast!(dt))
end
