defmodule Wsdjs.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts.User
  alias Wsdjs.Accounts.AuthToken

  @doc """
  Returns the list of users having new_song_notification: true

  ## Examples

      iex> list_users_to_notify(type)
      [%Accounts.User{}, ...]

  """
  def list_users_to_notify("new song") do
    query = from u in User,
      join: p in assoc(u, :parameter),
      where: u.deactivated == false
         and p.new_song_notification == true
         and u.profil_djvip == true
         and u.deactivated == false

    Repo.all(query)
  end
  def list_users_to_notify("radioking unmatch") do
    query = from u in User,
      join: p in assoc(u, :parameter),
      where: u.deactivated == false and p.radioking_unmatch == true

    Repo.all(query)
  end

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
    |> Repo.preload([:avatar, :songs, :comments, :parameter])
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

  def first_auth(%User{activated_at: nil} = user) do
    query = from User, where: [id: ^user.id]
    Repo.update_all(query, set: [activated_at: Timex.now])

    {:ok, user}
  end
  def first_auth(%User{} = user), do: {:ok, user}

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
    |> where([user_id: ^id])
    |> order_by([desc: :inserted_at])
    |> limit(1)
    |> Repo.all
  end

  ###############################################
  #
  # Invitation
  #
  ###############################################
  alias Wsdjs.Accounts.Invitation

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
    {:ok, user} = create_user(%{email: invitation.email, name: invitation.name})

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
