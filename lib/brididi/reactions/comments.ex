defmodule Brididi.Reactions.Comments do
  @moduledoc """
  """
  import Ecto.Query, warn: false

  alias Brididi.Accounts.User
  alias Brididi.Musics.Song
  alias Brididi.Reactions.Comments.Comment
  alias Brididi.Repo

  @doc """
  This policies of this module are
    - admin can do anything
    - user can delete its own comment
    - user can create an opinion
  """
  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, :delete, %Comment{user_id: id}), do: :ok
  def can?(%User{}, :create, _), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get!(123)
      %Comment{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Comment, id)

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list(%Song{})
      [%Comment{}, ...]
  """
  def list(%Song{id: id}) do
    Comment
    |> where(song_id: ^id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create(%{field: value})
      {:ok, %Comment{}}

      iex> create(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create(params) do
    {:ok, comment} =
      %Comment{}
      |> Comment.changeset(params)
      |> Repo.insert()

    {:ok, load_user(comment)}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change()
      %Ecto.Changeset{source: %Comment{}}

  """
  def change do
    Comment.changeset(%Comment{}, %{})
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete(comment)
      {:ok, %Comment{}}

      iex> delete(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Comment{} = comment) do
    Repo.delete(comment)
  end

  def load_user(comment), do: Repo.preload(comment, user: :user_profil)
end
