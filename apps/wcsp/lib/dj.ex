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

  def create_song!() do

  end

  def destroy_song() do

  end

  def update_song() do

  end

  def update_song_art() do

  end

  def find_song(id) do

  end

  def find_song(artist, title) do

  end

end
