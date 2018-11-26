defmodule Wsdjs.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.Query, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Accounts.User{}, ...]

  """
  def list_users do
    User
    |> order_by([:name])
    |> Repo.all()
    |> Repo.preload([:avatar, :songs, :comments, :parameter, :detail])
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Gets a single activated user.

  Raises `Ecto.NoResultsError` if the User does not exist or is deactivated.

  ## Examples

      iex> get_activated_user!(UUID)
      %User{}

      iex> get_activated_user!(unknow UUID)
      nil

  """
  def get_activated_user!(id) do
    User
    |> where(deactivated: false)
    |> Repo.get!(id)
    |> Repo.preload([:avatar, :detail, :parameter])
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> Repo.preload([:avatar, :detail, :parameter])
  end

  def get_user_by_email(email) do
    User
    |> Repo.get_by(email: String.downcase(email))
    |> Repo.preload([:avatar, :detail, :parameter])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs, %User{admin: false}) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_user(%User{} = user, attrs, %User{admin: true}) do
    user
    |> User.admin_changeset(attrs)
    |> Repo.update()
  end

  ###############################################
  #
  # Avatar
  #
  ###############################################
  alias Wsdjs.Accounts.Avatar

  @doc """
  Returns the user avatar.

  ## Examples

      iex> get_avatar(%User{})
      %Avatar{}
  """
  def get_avatar(%User{id: id}) do
    Avatar
    |> where(user_id: ^id)
    |> order_by(desc: :inserted_at)
    |> limit(1)
    |> Repo.all()
  end
end
