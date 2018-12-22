defmodule Wsdjs.Musics do
  @moduledoc """

  """
  import Ecto.Query, warn: false
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Songs
  alias Wsdjs.Repo

  @doc """
  Returns a song list according to a fulltext search.
  The song list is scoped by current user.
  """
  def search(%User{}, ""), do: []

  def search(%User{} = current_user, q) do
    q =
      q
      |> String.trim()
      |> String.split(" ")
      |> Enum.map(&"#{&1}:*")
      |> Enum.join(" & ")

    current_user
    |> Songs.scoped()
    |> preload([:art, user: :avatar])
    |> where(
      fragment(
        "(to_tsvector('english', coalesce(artist, '') || ' ' ||  coalesce(title, '')) @@ to_tsquery('english', ?))",
        ^q
      )
    )
    |> order_by(desc: :inserted_at)
    |> limit(10)
    |> Repo.all()
  end
end
