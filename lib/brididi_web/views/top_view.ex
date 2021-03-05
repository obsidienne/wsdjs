defmodule BrididiWeb.TopView do
  use BrididiWeb, :view

  def render("show.html", %{top: top} = assigns) do
    template =
      case top.status do
        "checking" -> "checking.html"
        "voting" -> "voting.html"
        "counting" -> "counting.html"
        "published" -> "published.html"
      end

    render_template(template, assigns)
  end

  def render("show.text", %{top: top} = assigns) do
    template =
      case top.status do
        "published" -> "published.text"
      end

    render_template(template, assigns)
  end

  def count_dj(songs) do
    songs
    |> Enum.map(fn x -> x.user_id end)
    |> Enum.uniq()
    |> Enum.count()
  end
end
