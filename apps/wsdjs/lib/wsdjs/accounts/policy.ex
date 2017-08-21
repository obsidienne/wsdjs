defmodule Wsdjs.Accounts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  - A connected user can create a song.
  - By default everything is denied.
  """
  alias Wsdjs.Accounts.User

  def can?(:logout, %User{id: id}, %User{id: id}), do: :ok

  def can?(:show_user, %User{admin: true}, %User{admin: true}), do: :ok
  def can?(:show_user, %User{admin: false}, _), do: :ok

  def can?(:edit_user, %User{}, %User{admin: true}), do: :ok
  def can?(:edit_user, %User{id: id}, %User{id: id}), do: :ok

  def can?(_, _, _), do: {:error, :unauthorized}
  def can?(_, _), do: {:error, :unauthorized}
end
