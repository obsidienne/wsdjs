defmodule Wsdjs.Accounts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  - A connected user can create a song.
  - By default everything is denied.
  """
  alias Wsdjs.Accounts.User

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, :logout, %User{id: id}), do: :ok
  def can?(nil, :show,  %User{admin: false}), do: :ok
  def can?(%User{admin: false}, :show, %User{admin: false}), do: :ok
  def can?(%User{id: id}, :edit_user, %User{id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(%User{profil_djvip: true}, :new_song_notification), do: :ok
  def can?(_, _), do: {:error, :unauthorized}
end
