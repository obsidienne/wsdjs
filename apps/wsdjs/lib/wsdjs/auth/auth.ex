defmodule Wsdjs.Auth do
  @moduledoc """
  The boundary for the Authentification system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo

  ###############################################
  #
  # Authentification
  #
  ###############################################
  alias Wsdjs.Accounts.User
  alias Wsdjs.Auth.AuthToken

  @token_max_age 1_800
  def get_magic_link_token(value) do
    AuthToken
    |> where([t], t.value == ^value)
    |> where(
      [t],
      t.inserted_at > datetime_add(^Ecto.DateTime.utc(), ^(@token_max_age * -1), "second")
    )
    |> Repo.one()
    |> Repo.preload(:user)
  end

  def set_magic_link_token(%User{} = user, token) do
    %AuthToken{}
    |> AuthToken.changeset(%{value: token, user_id: user.id})
    |> Repo.insert!()
  end

  def delete_magic_link_token!(token) do
    Repo.delete!(token)
  end

  def first_auth(%User{activated_at: nil} = user) do
    query = from(User, where: [id: ^user.id])
    Repo.update_all(query, set: [activated_at: Timex.now()])

    {:ok, user}
  end

  def first_auth(%User{} = user), do: {:ok, user}

  ###############################################
  #
  # Invitation
  #
  ###############################################
  alias Wsdjs.Auth.Invitation
  alias Wsdjs.Accounts

  @doc """
  Gets a single invitation.

  Raises `Ecto.NoResultsError` if the Invitation does not exist.

  ## Examples

      iex> get_invitation!(123)
      %Invitation{}

      iex> get_invitation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invitation!(id), do: Repo.get!(Invitation, id)

  @doc """
  Returns the list of invitations.

  ## Examples

      iex> list_invitations()
      [%Invitation{}, ...]

  """
  def list_invitations do
    Repo.all(Invitation)
  end

  @doc """
  """
  def accept_invitation(%Invitation{} = invitation) do
    {:ok, user} = Accounts.create_user(%{email: invitation.email, name: invitation.name})

    invitation
    |> Invitation.changeset(%{user_id: user.id})
    |> Repo.update()
  end

  @doc """
  Deletes an Invitation.

  ## Examples

      iex> delete_invitation(invitation)
      {:ok, %Invitation{}}

      iex> delete_invitation(invitation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invitation(%Invitation{} = invitation) do
    Repo.delete(invitation)
  end
end
