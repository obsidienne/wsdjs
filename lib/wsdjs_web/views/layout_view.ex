defmodule WsdjsWeb.LayoutView do
  use WsdjsWeb, :view

  @active_link "block px-3 py-2 rounded-md text-base font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700"
  @normal_link "mt-1 block px-3 py-2 rounded-md text-base font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700"
  def navbar_link(conn, text, to: route) do
    css =
      if route == Phoenix.Controller.current_path(conn) do
        @active_link
      else
        @normal_link
      end

    link(text, to: route, class: css)
  end

  @active_pill "px-3 py-2 rounded-md text-sm font-medium text-white bg-gray-900 focus:outline-none focus:text-white focus:bg-gray-700"
  @normal_pill "px-3 py-2 rounded-md text-sm font-medium text-gray-300 hover:text-white hover:bg-gray-700 focus:outline-none focus:text-white focus:bg-gray-700"
  def navbar_pill(conn, text, to: route), do: navbar_pill(conn, text, to: route, class: "")

  def navbar_pill(conn, text, to: route, class: class) do
    css =
      if route == Phoenix.Controller.current_path(conn) do
        @active_pill
      else
        @normal_pill
      end

    link(text, to: route, class: "#{class} #{css}")
  end
end
