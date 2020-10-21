defmodule Wsdjs.Reactions do
  @moduledoc """
  The boundary for the Reaction system.
  """
  import Ecto.{Query, Changeset}, warn: false

  alias Wsdjs.Reactions.Opinions

  def last_reactions(songs) when is_list(songs) do
    last_opinions =
      from o in Opinions.Opinion,
        select: %{
          id: o.id,
          song_id: o.song_id,
          row_number: row_number() |> over(:opinions_partition)
        },
        windows: [
          opinions_partition: [partition_by: :song_id, order_by: [desc: :inserted_at]]
        ]

    opinions_query =
      from o in Opinions.Opinion,
        join: r in subquery(last_opinions),
        on: o.id == r.id and r.row_number <= 4

    songs
    |> Wsdjs.Repo.preload(opinions: {opinions_query, [user: :avatar]})
  end
end
