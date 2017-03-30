defmodule Wcsp.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Accounts.User

#  alias Wcsp.Accounts.User
#  alias Wcsp.Accounts.Avatar

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(Wcsp.Accounts.User)
  end

  def find_user!(clauses) do
    User
    |> User.with_avatar()
    |> Repo.get_by!(clauses)
  end

  def find_user(clauses) do
    User
    |> User.with_avatar()
    |> Repo.get_by(clauses)
  end

  def find_user_with_songs(current_user, clauses) do
    User.scoped(current_user)
    |> User.with_avatar()
    |> User.with_songs(current_user)
    |> Repo.get_by(clauses)
  end
end
