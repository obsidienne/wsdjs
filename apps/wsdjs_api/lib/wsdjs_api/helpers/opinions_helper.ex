 defmodule WsdjsApi.OpinionsHelper do
  @moduledoc """
  This modules contains all helpers for a %Opinion{}. 
  Notably the html tag helpers.
  """
  import WsdjsApi.Router.Helpers

  defp data_method(kind, %Wsdjs.Reactions.Opinion{kind: my_kind}) when kind == my_kind, do: "DELETE"
  defp data_method(_, _), do: "POST"

  defp a_opinion_url(conn, kind, _song, %Wsdjs.Reactions.Opinion{kind: my_kind} = my_opinion) when kind == my_kind do
    api_opinion_path(conn, :delete, my_opinion.id)
  end
  defp a_opinion_url(conn, kind, song, _), do: song_opinion_path(conn, :create, song, kind: kind)

  defp opinions_names(kind, opinions) do
    kind_opinions = Enum.filter(opinions, fn(x) -> x.kind == kind end)
    names = Enum.map_join(Enum.take(kind_opinions, 3), "<br/>", &(&1.user.name))

    remaining_qty = Enum.count(opinions, fn(x) -> x.kind == kind end) - 3
    if remaining_qty > 0 do
      names <> "<br/> +#{remaining_qty} dj"
    else
      names
    end
  end
end
