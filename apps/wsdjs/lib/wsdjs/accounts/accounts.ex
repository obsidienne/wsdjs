defmodule Wsdjs.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts.User
  alias Wsdjs.Accounts.AuthToken

  @countries ["EN", "FR", "US"]

  def countries, do: @countries

  @doc """
  Returns the list of users having a particular configuration.

  ## Examples

      iex> list_users_having_config({new_song_notification: true})
      [%Accounts.User{}, ...]

  """
  def list_users(param) do
    User
    |> where(^param)
    |> Repo.all()
    |> Repo.preload(:avatar)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Accounts.User{}, ...]

  """
  def list_users do
    User
    |> Repo.all()
    |> Repo.preload(:avatar)
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
    |> Repo.get_by(email: String.downcase(email))
    |> Repo.preload(:avatar)
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
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def set_magic_link_token(%User{} = user, token) do
    %AuthToken{}
    |> AuthToken.changeset(%{value: token, user_id: user.id})
    |> Repo.insert!()
  end

  @token_max_age 1_800
  def get_magic_link_token(value) do
    AuthToken
    |> where([t], t.value == ^value)
    |> where([t], t.inserted_at > datetime_add(^Ecto.DateTime.utc, ^(@token_max_age * -1), "second"))
    |> Repo.one()
    |> Repo.preload(:user)
  end

  def delete_magic_link_token!(token) do
    Repo.delete!(token)
  end

end
