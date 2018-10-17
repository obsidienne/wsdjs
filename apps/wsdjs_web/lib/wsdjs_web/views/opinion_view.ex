defmodule WsdjsWeb.OpinionView do
  use WsdjsWeb, :view

  import WsdjsWeb.Router.Helpers

  def count(opinions, kind) when kind in ["up", "down", "like"] do
    Enum.count(opinions, fn x -> x.kind == kind end)
  end

  def current_opinion(opinions, current_user) do
    opinion = Enum.find(opinions, fn x -> x.user_id == current_user.id end)

    if is_nil(opinion) do
      nil
    else
      opinion.kind
    end
  end

  def options(kind, _conn, _song, opinions, nil) do
    qty = Enum.count(opinions, fn x -> x.kind == kind end)
    default_options = [class: "song-opinion border-0 p-2 song-#{kind}"]

    default_options ++ tooltip_options(kind, opinions, qty)
  end

  def options(kind, conn, song, opinions, current_user) do
    qty = Enum.count(opinions, fn x -> x.kind == kind end)

    my_opinion = Enum.find(opinions, fn x -> x.user_id == current_user.id end)

    default_options = [
      "data-url": opinion_url(conn, kind, song, my_opinion),
      class: html_class(kind, my_opinion),
      "data-local-method": data_method(kind, my_opinion)
    ]

    default_options ++ tooltip_options(kind, opinions, qty)
  end

  def opinions_names(kind, opinions) do
    kind_opinions = Enum.filter(opinions, fn x -> x.kind == kind end)
    names = Enum.map_join(Enum.take(kind_opinions, 3), "<br/>", & &1.user.name)

    remaining_qty = Enum.count(opinions, fn x -> x.kind == kind end) - 3

    if remaining_qty > 0 do
      names <> "<br/> +#{remaining_qty} dj"
    else
      names
    end
  end

  defp tooltip_options(kind, opinions, qty) when qty > 0 do
    ["data-tippy": opinions_names(kind, opinions)]
  end

  defp tooltip_options(_kind, _opinions, qty) when qty == 0, do: []

  defp data_method(kind, %Wsdjs.Reactions.Opinion{kind: my_kind}) when kind == my_kind,
    do: "DELETE"

  defp data_method(_, _), do: "POST"

  defp opinion_url(conn, kind, _song, %Wsdjs.Reactions.Opinion{kind: my_kind} = my_opinion)
       when kind == my_kind do
    api_opinion_path(conn, :delete, my_opinion.id)
  end

  defp opinion_url(conn, kind, song, _),
    do: api_song_opinion_path(conn, :create, song, kind: kind)

  defp html_class(kind, %Wsdjs.Reactions.Opinion{kind: my_kind}) when kind == my_kind,
    do: "song-opinion border-0 p-2 song-#{kind} active hvr-buzz-out"

  defp html_class(kind, _),
    do: "song-opinion border-0 p-2 song-#{kind} hvr-buzz-out"
end
