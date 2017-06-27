defmodule Wsdjs.Musics.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  @doc """
  A connected user can create a song
  """
  def can?(:create_song, %User{}), do: true

  def can?(:edit_user, %User{admin: true}, %Song{}), do: true
  def can?(:edit_user, %User{id: id}, %Song{user_id: id}), do: true


  @doc """
  By default everything is denied
  """
  def can?(_, _, _), do: false
  def can?(_, _), do: false
end
