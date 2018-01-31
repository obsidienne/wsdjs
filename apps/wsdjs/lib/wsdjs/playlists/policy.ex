defmodule Wsdjs.Playlists.Policy do
  alias Wsdjs.Accounts.User

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, :create, %User{id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(_, _), do: {:error, :unauthorized}
end
