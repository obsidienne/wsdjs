defmodule Wsdjs.Searches do
  @moduledoc """
  The boundary for the Notification system.
  """
  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo
  alias Wsdjs.Musics.Song
  alias Wsdjs.Accounts.User

  @doc """
  Returns a song list according to a fulltext search.
  The song list is scoped by current user.
  """
  def search(%User{}, ""), do: []
  def search(%User{} = current_user, q) do
    q = q
        |> String.trim
        |> String.split(" ")
        |> Enum.map(&("#{&1}:*"))
        |> Enum.join(" & ")

    current_user
    |> Song.scoped()
    |> preload([:art, user: :avatar])
    |> where(fragment("(to_tsvector('english', coalesce(artist, '') || ' ' ||  coalesce(title, '')) @@ to_tsquery('english', ?))", ^q))
    |> order_by([desc: :inserted_at])
    |> limit(10)
    |> Repo.all()
  end
end
