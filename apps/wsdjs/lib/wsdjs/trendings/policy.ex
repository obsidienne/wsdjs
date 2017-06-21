defmodule Wsdjs.Trendings.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  @doc """
  A connected user can create a song
  """
  def can?(:create_top, %User{admin: :true}), do: true


  @doc """
  By default everything is denied
  """
  def can?(_, _), do: false
end
