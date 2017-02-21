defmodule WsdjsWeb.OpinionsHelper do
  use Phoenix.HTML

  import WsdjsWeb.Router.Helpers

  def opinion_link(kind, conn, song, current_user) do
    my_opinion = Enum.find(song.song_opinions, fn(x) -> x.user_id == current_user.id end)
    qty = opinions_count(kind, song.song_opinions)

    link to: opinion_url(conn, kind, song, my_opinion),
         class: html_class(kind, my_opinion),
         "data-remote": "true",
         "data-method": data_method(kind, my_opinion) do
      raw("<span>#{qty}</span>")
    end
  end

  def opinions_count("like", opinions), do: Enum.count(opinions, fn(x) -> x.kind == "like" end)
  def opinions_count("up", opinions), do: Enum.count(opinions, fn(x) -> x.kind == "up" end)
  def opinions_count("down", opinions), do: Enum.count(opinions, fn(x) -> x.kind == "down" end)

  def data_method(_kind, my_opinion) when is_nil(my_opinion), do: "POST"
  def data_method(kind, my_opinion) do
    if kind == my_opinion.kind do
      "DELETE"
    else
      "POST"
    end
  end

  def opinion_url(conn, kind, song, my_opinion) when is_nil(my_opinion) do
    song_song_opinion_path(conn, :create, song, kind: kind)
  end

  def opinion_url(conn, kind, song, my_opinion) do
    if kind == my_opinion.kind do
      api_song_opinion_path(conn, :delete, my_opinion.id)
    else
      api_song_opinion_path(conn, :create, song, kind: kind)
    end
  end

  def html_class(kind, my_opinion) when is_nil(my_opinion) do
    "song-opinion song-#{kind}"
  end
  def html_class(kind, my_opinion) do
    if kind == my_opinion.kind do
      "song-opinion song-#{kind} active"
    else
      "song-opinion song-#{kind}"
    end
  end
end
