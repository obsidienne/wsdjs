defmodule Wsdjs.Musics.Policy do
  @moduledoc """
  The Policies for the Dj system. Access is managed by scoped in module.
  The rules are the following
    - A connected user can create a song.
    - Admin can edit a song.
    - A connected user can edit his own song.
    - Admin can delete a song.
    - A connected user can delete his own song.
    - By default everything is denied.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  def can?(:search, %User{}), do: true
  def can?(:list_user_suggestions, %User{}), do: true
  def can?(:create_song, %User{}), do: true
  def can?(:edit_song, %User{admin: true}, %Song{}), do: true
  def can?(:edit_song, %User{id: id}, %Song{user_id: id}), do: true
  def can?(:delete_song, %User{admin: true}, %Song{}), do: true
  def can?(:delete_song, %User{id: id}, %Song{user_id: id}), do: true
  def can?(_, _, _), do: false
  def can?(_, _), do: false
end
