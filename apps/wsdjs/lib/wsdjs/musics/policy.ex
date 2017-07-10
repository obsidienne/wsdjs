defmodule Wsdjs.Musics.Policy do
  @moduledoc """
  The Policies for the Dj system. Access is managed by scoped in module.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  @doc "A connected user can create a song."
  def can?(:create_song, %User{}), do: true

  @doc "Admin can edit a song."
  def can?(:edit_song, %User{admin: true}, %Song{}), do: true
  @doc "A connected user can edit his own song."
  def can?(:edit_song, %User{id: id}, %Song{user_id: id}), do: true

  @doc "Admin can delete a song."
  def can?(:delete_song, %User{admin: true}, %Song{}), do: true
  @doc "A connected user can delete his own song."
  def can?(:delete_song, %User{id: id}, %Song{user_id: id}), do: true


  @doc """
  By default everything is denied
  """
  def can?(_, _, _), do: false
  def can?(_, _), do: false
end
