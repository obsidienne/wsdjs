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
    |> load_avatar()
    |> load_songs()
    |> load_comments()
    |> load_parameter()
    |> load_detail()
  end

  def load_avatar(user), do: Repo.preload(user, :avatar)
  def load_songs(user), do: Repo.preload(user, :songs)
  def load_comments(user), do: Repo.preload(user, :comments)
  def load_parameter(user), do: Repo.preload(user, :parameter)
  def load_detail(user), do: Repo.preload(user, :detail)

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
    |> load_avatar()
    |> load_detail()
    |> load_parameter()
  end

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> load_avatar()
    |> load_detail()
    |> load_parameter()
  end

  def get_user_by_email(email) do
    User
    |> Repo.get_by(email: String.downcase(email))
    |> load_avatar()
    |> load_detail()
    |> load_parameter()
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
end
