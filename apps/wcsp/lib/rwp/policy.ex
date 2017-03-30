defmodule Wcsp.Policy do
  use Wcsp.Schema

  alias Wcsp.Musics.Songs

  @doc """
  admin can do anything
  """
  def can?(%User{admin: :true}, _action, _struct), do: true

  @doc """
  User can do anything to his own suggested song
  """
  def can?(%User{id: user_id}, _action, %Songs{user_id: user_id}), do: true

  @doc """
  A connected user can create, show a song
  """
  def can?(%User{}, action, %Songs{}) when action in [:create, :show], do: true

  @doc """
  Not connected user can show a song. Restriction by the Song scope
  """
  def can?(nil, :show, %Songs{}), do: true

  @doc """
  If no previous match, by default everything is denied
  """
  def can?(_, _, _), do: false
end
