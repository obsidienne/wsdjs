 defmodule Wsdjs.OpinionsHelper do
  use Phoenix.HTML

  import Wsdjs.Router.Helpers

  def opinion_link(kind, _conn, _song, opinions, nil) do
    qty = Enum.count(opinions, fn(x) -> x.kind == kind end)
    default_options = [class: "song-opinion song-#{kind}"]

    content_tag :span, qty, default_options ++ tooltip_options(kind, opinions, qty)
  end

  def opinion_link(kind, conn, song, opinions, current_user) do
    qty = Enum.count(opinions, fn(x) -> x.kind == kind end)
    my_opinion = Enum.find(opinions, fn(x) -> x.user_id == current_user.id end)

    default_options = [
      "data-url": opinion_url(conn, kind, song, my_opinion),
      class: html_class(kind, my_opinion),
      "data-method": data_method(kind, my_opinion)
    ]
    content_tag :button, qty, default_options ++ tooltip_options(kind, opinions, qty)
  end

  defp tooltip_options(kind, opinions, qty) when qty > 0 do
    ["data-balloon": opinions_names(kind, opinions), "data-balloon-pos": "up", "data-balloon-break": "true"]
  end
  defp tooltip_options(_kind, _opinions, qty) when qty == 0, do: []

  defp data_method(kind, %Wcsp.Musics.Opinion{kind: my_kind}) when kind == my_kind, do: "DELETE"
  defp data_method(_, _), do: "POST"

  defp opinion_url(conn, kind, _song, %Wcsp.Musics.Opinion{kind: my_kind} = my_opinion) when kind == my_kind do
    api_opinion_path(conn, :delete, my_opinion.id)
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
