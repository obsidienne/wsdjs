defmodule WsdjsWeb.SongOpinionView do
  use WsdjsWeb.Web, :view

  def opinion_link(kind, conn, song, current_user) do
    html_class = "song-opinion song-#{kind} #{my_opinion(kind, song.song_opinions, current_user)}"
    data_method = opinions_method(kind, song.song_opinions, current_user)
    qty = opinions_count(kind, song.song_opinions)

    link to: song_song_opinion_path(conn, :create, song, kind: kind),
         class: html_class,
         "data-remote": "true",
         "data-method": data_method do
      raw("<span>#{qty}</span>")
    end
  end

  def opinions_count(:like, opinions), do: Enum.count(opinions, fn(x) -> x.kind == "like" end)
  def opinions_count(:up, opinions), do: Enum.count(opinions, fn(x) -> x.kind == "up" end)
  def opinions_count(:down, opinions), do: Enum.count(opinions, fn(x) -> x.kind == "down" end)

  def opinions_method(kind, opinions, current_user) do
    if Enum.any?(opinions, fn(x) -> x.kind == kind and x.user_id == current_user.id end) do
      "delete"
    else
      "post"
    end
  end

  def my_opinion(kind, opinions, current_user) do
    if Enum.any?(opinions, fn(x) -> x.kind == kind and x.user_id == current_user.id end) do
      "active"
    end
  end
end
