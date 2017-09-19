defmodule Wsdjs.Musics.Policy do
  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song
  alias Wsdjs.Repo

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, _, %Song{user_id: id}), do: :ok
  def can?(_, :show, %Song{public_track: true}), do: :ok
  def can?(_, :show, %Song{instant_hit: true}), do: :ok
  def can?(%User{profil_djvip: true}, :show, %Song{hidden_track: true}), do: :ok
  def can?(user, :show, %Song{id: id}) do
    song = Repo.get(Song.scoped(user), id)
    case song  do
      %Song{} -> :ok
      nil -> {:error, :unauthorized}
    end
  end
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{}, :create_comment), do: :ok
  def can?(%User{profil_djvip: true}, :create_song), do: :ok
  def can?(%User{}, :search), do: :ok
  def can?(%User{}, :list_user_suggestions), do: :ok

  def can?(_, _), do: {:error, :unauthorized}
end
