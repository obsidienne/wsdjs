defmodule Wsdjs.Accounts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  - A connected user can create a song.
  - By default everything is denied.
  """
  alias Wsdjs.Accounts.User

  def can?(:logout, %User{id: id}, %User{id: id}), do: true

  def can?(:edit_user, %User{}, %User{admin: true}), do: true
  def can?(:edit_user, %User{id: id}, %User{id: id}), do: true

  def can?(_action, _user, _resource), do: false
  def can?(_action, _user), do: false
end
