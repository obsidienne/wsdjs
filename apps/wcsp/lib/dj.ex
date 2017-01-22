defmodule Wcsp.Dj do
  @moduledoc ~S"""
  Contains dj business logic of the platform.

  `Dj` will be used by `wcs_web` Phoenix apps.
  """
  alias Wcsp.Repo
  use Wcsp.Model

  def songs_with_album_art() do
    Repo.all from p in Song, preload: [:album_art, :account]
  end

  def find_song(id) do
    song = Repo.get(Song, id)
    song = Repo.preload(song, [:album_art, :account])
  end

  def tops do
    tops = Wcsp.Top.tops() |> Repo.all
    Repo.preload tops, ranks: Wcsp.Rank.for_tops_with_limit()
  end

  def top(id) do
    top = Wcsp.Top.top(id) |> Repo.one
    top_with_songs = Repo.preload top, ranks: Wcsp.Rank.for_top(id)
  end

end
