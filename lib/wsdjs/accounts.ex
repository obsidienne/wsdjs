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
    |> order_by([:email])
    |> Repo.all()
    |> load_avatar()
    |> load_songs()
    |> load_comments()
    |> load_profil()
  end

  def load_avatar(user), do: Repo.preload(user, :avatar)
  def load_songs(user), do: Repo.preload(user, :songs)
  def load_comments(user), do: Repo.preload(user, :comments)
  def load_profil(user), do: Repo.preload(user, :profil)

  def list_users(criteria) when is_list(criteria) do
    query = from(d in User)

    Enum.reduce(criteria, query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from q in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]
    end)
    |> Repo.all()
    |> load_avatar()
    |> load_songs()
    |> load_comments()
    |> load_profil()
  end

  def list_djs do
    User
    |> limit(7)
    |> where(profil_djvip: true)
    |> Repo.all()
    |> load_avatar()
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

  def get_user!(id) do
    User
    |> Repo.get!(id)
    |> load_avatar()
    |> load_profil()
  end

  def get_user_by_email(email) do
    User
    |> Repo.get_by(email: String.downcase(email))
    |> load_avatar()
    |> load_profil()
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