defmodule Wsdjs.Reactions.Policy do
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song
  alias Wsdjs.Repo

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(%User{}, :create_comment), do: :ok
  def can?(_, _), do: {:error, :unauthorized}
end
