defmodule Wcsp do
  @moduledoc ~S"""
  Contains main business logic of the project.

  `Wcsp` is used by `wsdjs_web` Phoenix app.
  """
  use Wcsp.Model

  def find_song!(clauses) do
    Repo.get_by!(Song, clauses)
    |> Repo.preload([:album_art, :account])
  end
end
