defmodule Wsdjs.Playlists.Policy do
  @moduledoc """
  ## Examples
      iex> can?(%User{admin: true}, :create)
      :ok
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Playlists.Playlist

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, :edit, %Playlist{user_id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(_, _), do: {:error, :unauthorized}
end
