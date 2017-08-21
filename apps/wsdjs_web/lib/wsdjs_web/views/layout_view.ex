defmodule WsdjsWeb.LayoutView do
  use WsdjsWeb, :view

  @doc """
  Generates name for the JavaScript view we want to use
  in this combination of view/template.
  """
  def js_view_name(conn, view_template) do
    [view_name(conn), template_name(view_template)]
    |> Enum.reverse
    |> List.insert_at(0, "view")
    |> Enum.map(&String.capitalize/1)
    |> Enum.reverse
    |> Enum.join("")
  end

  # Takes the resource name of the view module and removes the
  # the ending *_view* string.
  defp view_name(conn) do
    conn
    |> view_module
    |> Phoenix.Naming.resource_name
    |> String.replace("_view", "")
  end

  # Removes the extion from the template and reutrns
  # just the name.
  defp template_name(template) when is_binary(template) do
    template
    |> String.split(".")
    |> Enum.at(0)
  end


  @suffix "WSDJs"

  def page_title(conn) do
    controller = view_name(conn)
    action = action_name(conn)

    title = get(controller, action)
    put_suffix(title)
  end

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title <> " - " <> @suffix

  defp get("home", :index), do: "Home page"
  defp get("song", :index), do: "Songs"
  defp get("user", :index), do: "Users"
  defp get("top", :index), do: "Tops"
  
  defp get(_, _), do: nil
end
