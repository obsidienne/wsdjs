defmodule WsdjsApi.Trendings do
  @moduledoc """
  The boundary for the Trendings system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias WsdjsApi.Repo

  alias WsdjsApi.Trendings.Rank

  @doc """
  Returns the list of ranks.

  ## Examples

      iex> list_ranks()
      [%Rank{}, ...]

  """
  def list_ranks do
    Repo.all(Rank)
  end

  @doc """
  Gets a single rank.

  Raises `Ecto.NoResultsError` if the Rank does not exist.

  ## Examples

      iex> get_rank!(123)
      %Rank{}

      iex> get_rank!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rank!(id), do: Repo.get!(Rank, id)

  @doc """
  Creates a rank.

  ## Examples

      iex> create_rank(rank, %{field: value})
      {:ok, %Rank{}}

      iex> create_rank(rank, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rank(attrs \\ %{}) do
    %Rank{}
    |> rank_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rank.

  ## Examples

      iex> update_rank(rank, %{field: new_value})
      {:ok, %Rank{}}

      iex> update_rank(rank, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rank(%Rank{} = rank, attrs) do
    rank
    |> rank_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Rank.

  ## Examples

      iex> delete_rank(rank)
      {:ok, %Rank{}}

      iex> delete_rank(rank)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rank(%Rank{} = rank) do
    Repo.delete(rank)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rank changes.

  ## Examples

      iex> change_rank(rank)
      %Ecto.Changeset{source: %Rank{}}

  """
  def change_rank(%Rank{} = rank) do
    rank_changeset(rank, %{})
  end

  defp rank_changeset(%Rank{} = rank, attrs) do
    rank
    |> cast(attrs, [:likes, :votes, :bonus, :position])
    |> validate_required([:likes, :votes, :bonus, :position])
  end
end
