defmodule Wsdjs.Auth do
  @moduledoc """
  The boundary for the Authentification system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo
  alias Wsdjs.Accounts

  ###############################################
  #
  # Invitation
  #
  ###############################################
  alias Wsdjs.Auth.Invitation

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
