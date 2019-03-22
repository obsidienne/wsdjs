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

  def active_class(conn, val) do
    if Enum.member?(val, view_name(conn)) do
      "active"
    else
      ""
    end
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

  @suffix "World Swing DJs"

  def main_title(conn) do
    controller = view_name(conn)
    action = action_name(conn)

    get(controller, action)
  end

  def page_title(conn) do
    conn |> main_title() |> put_suffix()
  end

  defp put_suffix(nil), do: @suffix
  defp put_suffix(title), do: title <> " - " <> @suffix

  defp get("home", :index), do: "Home"
  defp get("song", :index), do: "List songs"
  defp get("song", :show), do: "Song"
  defp get("user", :index), do: "List users"
  defp get("user", :show), do: "User"
  defp get("user", :edit), do: "Edit user"
  defp get("top", :index), do: "List tops"

  defp get(_, _), do: nil
end
