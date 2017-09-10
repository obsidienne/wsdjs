defmodule Wsdjs.Musics.Policy do
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song

  def can?(_, %User{admin: true}, _), do: :ok
  def can?(_, %User{id: id}, %Song{user_id: id}), do: :ok

  def can?(:show, %Song{public_track: true}, %User{}), do: :ok
  def can?(:show, %Song{instant_hit: true}, %User{}), do: :ok
  def can?(:show, %Song{} = song, user), do: :ok

  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(:create_comment, %User{profils: profils}) do
    if Enum.member?(profils, "DJ_VIP") do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  def can?(:search, %User{}), do: :ok
  def can?(:list_user_suggestions, %User{}), do: :ok

  def can?(:create_song, %User{profils: profils}) do
    if Enum.member?(profils, "DJ_VIP") do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  def can?(_, _), do: {:error, :unauthorized}
end
