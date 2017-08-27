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

  def can?(:edit_song, %User{admin: true}, %Song{}), do: :ok
  def can?(:edit_song, %User{id: id}, %Song{user_id: id}), do: :ok
  def can?(:delete_song, %User{admin: true}, %Song{}), do: :ok
  def can?(:delete_song, %User{id: id}, %Song{user_id: id}), do: :ok

  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(:search, %User{}), do: :ok
  def can?(:list_user_suggestions, %User{}), do: :ok
  def can?(:create_song, %User{admin: true}), do: :ok

  def can?(:create_song, %User{profils: profils}) do
    if Enum.member?(profils, "DJ_VIP") do
      :ok
    else
      {:error, :unauthorized}
    end
  end
  
  def can?(_, _), do: {:error, :unauthorized}
end
