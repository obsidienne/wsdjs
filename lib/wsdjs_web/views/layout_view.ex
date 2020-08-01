defmodule WsdjsWeb.LayoutView do
  use WsdjsWeb, :view

  @doc """
  Generates name for the JavaScript view we want to use
  in this combination of view/template.
  """
  def js_view_name(conn, view_template) do
    [view_name(conn), template_name(view_template)]
    |> Enum.reverse()
    |> List.insert_at(0, "view")
    |> Enum.map(&String.capitalize/1)
    |> Enum.reverse()
    |> Enum.join("")
  end

  # Takes the resource name of the view module and removes the
  # the ending *_view* string.
  defp view_name(conn) do
    conn
    |> view_module
    |> Phoenix.Naming.resource_name()
    |> String.replace("_view", "")
  end

  # Removes the extion from the template and reutrns
  # just the name.
  defp template_name(template) when is_binary(template) do
    template
    |> String.split(".")
    |> Enum.at(0)
  end

  def current_user_id(nil), do: nil
  def current_user_id(%Wsdjs.Accounts.User{} = user), do: user.id

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
