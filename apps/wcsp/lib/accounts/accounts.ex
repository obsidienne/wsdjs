defmodule Wcsp.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wcsp.Repo

  alias Wcsp.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Accounts.User{}, ...]

  """
  def list_users do
    Repo.all(Wcsp.Accounts.User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload(:avatar)
  end

  def get_user_by_email(email) do
    User
    |> Repo.get_by(email: email)
    |> Repo.preload(:avatar)
  end

  def get_user_with_songs(current_user, id) do
    User.scoped(current_user)
    |> User.with_songs(current_user)
    |> Repo.get(id)
    |> Repo.preload(:avatar)
  end
end
