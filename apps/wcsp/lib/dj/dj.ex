defmodule Wcsp.Dj do
  @moduledoc """
  The boundary for the Dj system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Song

  @doc """
  Returns the list of songs.the current and previous month

  ## Examples

      iex> list_songs()
      [%User{}, ...]

  """
  def list_songs(current_user) do
    Song.scoped(current_user)
    |> Song.with_all()
    |> Song.last_month()
    |> Repo.all
  end
end
