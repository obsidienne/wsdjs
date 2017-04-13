 defmodule Wsdjs.OpinionsHelper do
  use Phoenix.HTML

  import Wsdjs.Router.Helpers

  def opinion_link(kind, _conn, _song, opinions, nil) do
    options = [class: "song-opinion song-#{kind}"]

    qty = Enum.count(opinions, fn(x) -> x.kind == kind end)
    if qty > 0 do
      options = options ++ ["data-balloon": opinions_names(kind, opinions), "data-balloon-pos": "up", "data-balloon-break": "true"]
    end

    content_tag :span, qty, options
  end

  def opinion_link(kind, conn, song, opinions, current_user) do
    my_opinion = Enum.find(opinions, fn(x) -> x.user_id == current_user.id end)
    qty = Enum.count(opinions, fn(x) -> x.kind == kind end)

    if qty == 0 do
      link to: opinion_url(conn, kind, song, my_opinion),
           class: html_class(kind, my_opinion),
           "data-method": data_method(kind, my_opinion) do
        qty
      end
    else
      link to: opinion_url(conn, kind, song, my_opinion),
           class: html_class(kind, my_opinion),
           "data-balloon": opinions_names(kind, opinions),
           "data-balloon-pos": "up",
           "data-balloon-break": "true",
           "data-method": data_method(kind, my_opinion) do
        qty
      end
    end
  end

  defp data_method(kind, %Wcsp.Musics.Opinion{kind: my_kind}) when kind == my_kind, do: "DELETE"
  defp data_method(_, _), do: "POST"

  defp opinion_url(conn, kind, _song, %Wcsp.Musics.Opinion{kind: my_kind} = my_opinion) when kind == my_kind do
    api_song_opinion_path(conn, :delete, my_opinion.id)
  end
  defp opinion_url(conn, kind, song, _), do: api_song_opinion_path(conn, :create, song, kind: kind)

  defp html_class(kind, %Wcsp.Musics.Opinion{kind: my_kind}) when kind == my_kind, do: "song-opinion song-#{kind} active"
  defp html_class(kind, _), do: "song-opinion song-#{kind}"

  defp opinions_names(kind, opinions) do
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
