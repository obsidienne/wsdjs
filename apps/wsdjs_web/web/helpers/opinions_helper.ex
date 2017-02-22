defmodule WsdjsWeb.OpinionsHelper do
  use Phoenix.HTML

  import WsdjsWeb.Router.Helpers

  def opinion_link(kind, conn, song, nil) do
    qty = opinions_count(kind, song.song_opinions)

    if qty == 0 do
      content_tag :span, qty, class: "song-opinion song-#{kind}"
    else
      content_tag :span,
                  class: "song-opinion song-#{kind}",
                  "data-balloon": opinions_names(kind, song.song_opinions),
                  "data-balloon-pos": "up",
                  "data-balloon-break": "true" do
        qty
      end
    end

  end

  def opinion_link(kind, conn, song, current_user) do
    my_opinion = Enum.find(song.song_opinions, fn(x) -> x.user_id == current_user.id end)
    qty = opinions_count(kind, song.song_opinions)

    if qty == 0 do
      link to: opinion_url(conn, kind, song, my_opinion),
           class: html_class(kind, my_opinion),
           "data-method": data_method(kind, my_opinion) do
        raw("<span>#{qty}</span>")
      end
    else
      link to: opinion_url(conn, kind, song, my_opinion),
           class: html_class(kind, my_opinion),
           "data-balloon": opinions_names(kind, song.song_opinions),
           "data-balloon-pos": "up",
           "data-balloon-break": "true",
           "data-method": data_method(kind, my_opinion) do
        raw("<span>#{qty}</span>")
      end
    end
  end

  def opinions_count(kind, opinions), do: Enum.count(opinions, fn(x) -> x.kind == kind end)

  def data_method(kind, %Wcsp.SongOpinion{kind: my_kind} = my_opinion) when kind == my_kind, do: "DELETE"
  def data_method(_, _), do: "POST"

  def opinion_url(conn, kind, song, %Wcsp.SongOpinion{kind: my_kind} = my_opinion) when kind == my_kind do
    api_song_opinion_path(conn, :delete, my_opinion.id)
  end
  def opinion_url(conn, kind, song, _), do: api_song_opinion_path(conn, :create, song, kind: kind)

  def html_class(kind, %Wcsp.SongOpinion{kind: my_kind} = my_opinion) when kind == my_kind, do: "song-opinion song-#{kind} active"
  def html_class(kind, _), do: "song-opinion song-#{kind}"

  def opinions_names(kind, opinions) do
    kind_opinions = Enum.filter(opinions, fn(x) -> x.kind == kind end)
    names = Enum.map_join(Enum.take(kind_opinions, 4), "\u000A", &(&1.user.name))

    remaining_qty = Enum.count(opinions, fn(x) -> x.kind == kind end) - 4
    if remaining_qty > 0 do
      names <> "\u000A+ #{remaining_qty} dj"
    else
      names
    end
  end
end
