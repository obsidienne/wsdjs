defmodule Wcsp.Policy do
  use Wcsp.Schema

  @doc """
  admin can do anything
  """
  def can?(%User{admin: :true}, _action, _struct), do: true

  @doc """
  User can do anything to his own suggested song
  """
  def can?(%User{id: user_id}, _action, %Song{user_id: user_id}), do: true

  @doc """
  A connected user can create, show a song
  """
  def can?(%User{}, action, %Song{}) when action in [:create, :show], do: true

  @doc """
  Not connected user can show a song. Restriction by the Song scope
  """
  def can?(nil, :show, %Song{}), do: true

  @doc """
  If no previous match, by default everything is denied
  """
  def can?(_, _, _), do: false
end
