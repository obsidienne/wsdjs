defmodule Wsdjs.Accounts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User

  @doc """
  A connected user can create a song
  """
  def can?(:edit_user, %User{admin: true}, _), do: true
  def can?(:edit_user, %User{id: id}, %User{id: id}), do: true


  @doc """
  By default everything is denied
  """
  def can?(_, _, _), do: false
  def can?(_, _), do: false
end
