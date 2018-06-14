defmodule Wsdjs.Reactions.Policy do
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song
  alias Wsdjs.Reactions.Comment
  alias Wsdjs.Reactions.Opinion

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, :delete, %Comment{user_id: id}), do: :ok
  def can?(%User{}, :create_opinion, %Song{}), do: :ok
  def can?(%User{id: id}, :delete, %Opinion{user_id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(%User{}, :create_comment), do: :ok
  def can?(_, _), do: {:error, :unauthorized}
end
