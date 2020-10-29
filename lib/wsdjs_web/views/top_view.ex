defmodule WsdjsWeb.TopView do
  use WsdjsWeb, :view

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

  def all_genre(songs) do
    {:safe,
     songs
     |> Enum.sort(&(&1 <= &2))
     |> Enum.group_by(fn x -> x.genre end)
     |> Enum.map(fn {k, v} -> {k, Enum.count(v)} end)
     |> Enum.sort(fn {_, v1}, {_, v2} -> v1 >= v2 end)
     |> Enum.map(fn {k, v} -> "#{k} <span class=\"text-gray-800\">(#{v})</span>" end)
     |> Enum.join(", ")}
  end

  def get_song_by(top, user, position) do
    vote =
      Enum.find(top.votes, fn vote ->
        vote.votes == position && vote.user_id == user.id
      end)

    if vote do
      song = Enum.find(top.songs, fn song -> song.id == vote.song_id end)
      {:safe, "#{song.title}"}
    else
      ""
    end
  end

  def top_full_description(song) do
    date_str =
      song.inserted_at
      |> Timex.to_date()
      |> Timex.format!("%b %Y", :strftime)

    "TOP 10 #{date_str}"
  end
end
