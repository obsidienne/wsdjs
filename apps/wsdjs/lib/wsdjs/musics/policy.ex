defmodule Wsdjs.Musics.Policy do
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  def can?(_, %User{admin: true}, _), do: :ok
  def can?(_, %User{id: id}, %Song{user_id: id}), do: :ok

  def can?(:show, %Song{public_track: true}, _), do: :ok
  def can?(:show, %Song{instant_hit: true}, _), do: :ok
  def can?(:show, %Song{} = song, user), do: :ok

  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(:create_comment, %User{profil_djvip: true}), do: :ok

  def can?(:search, %User{}), do: :ok
  def can?(:list_user_suggestions, %User{}), do: :ok

  def can?(_, _), do: {:error, :unauthorized}
end
