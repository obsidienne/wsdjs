defmodule Wsdjs.Playlists.Policy do
  @moduledoc """
  ## Examples
      iex> can?(%User{admin: true}, :create)
      :ok
  """
  alias Wsdjs.Accounts.User

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(_, _), do: {:error, :unauthorized}
end
