defmodule WsdjsWeb.TopView do
  use WsdjsWeb.Web, :view

  def proposed_by_display_name(%{name: name, djname: djname})
    when is_binary(djname), do: "#{name} (#{djname})"
  def proposed_by_display_name(%{name: name}), do: name
end
