defmodule Wsdjs.Accounts.Users do
  @moduledoc """

  """
  import Ecto.Query, warn: false
  alias Wsdjs.Accounts

  @doc """
  The policies are
    - admin can do anything
    - user can disconnect himself
    - non admin user are public
    - a user can edit himself
  """
  def can?(%Accounts.User{admin: true}, action, _) when action not in [:logout], do: :ok
  def can?(%Accounts.User{id: id}, :logout, %Accounts.User{id: id}), do: :ok
  def can?(_, :show, %Accounts.User{admin: false}), do: :ok
  def can?(%Accounts.User{id: id}, :edit_user, %Accounts.User{id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%Accounts.User{admin: true}, _), do: :ok
  def can?(%Accounts.User{profil_djvip: true}, :new_song_notification), do: :ok
  def can?(_, _), do: {:error, :unauthorized}

  @doc """
  The function scope is used to filter the users according to the user specified.
  - Admin see every user
  - Connected user can every users exceptsee himself and not admin users
  - Not connected users see nothing
  """
  def scoped(%Accounts.User{admin: true}), do: Accounts.User

  def scoped(%Accounts.User{} = user) do
    from(u in Accounts.User, where: u.id == ^user.id or u.admin == false)
  end

  def scoped(_), do: from(u in Accounts.User, where: u.admin == false)
end
