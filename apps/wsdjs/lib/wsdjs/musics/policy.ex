defmodule Wsdjs.Musics.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  @doc """
  A connected user can create a song
  """
  def can?(:create_song, user) when user != nil, do: true


  @doc """
  By default everything is denied
  """
  def can?(_, _), do: false
end
