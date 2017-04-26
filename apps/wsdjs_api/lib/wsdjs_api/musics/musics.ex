defmodule WsdjsApi.Musics do
  @moduledoc """
  The boundary for the Musics system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias WsdjsApi.Repo

  alias WsdjsApi.Musics.Opinion

  @doc """
  Returns the list of opinions.

  ## Examples

      iex> list_opinions()
      [%Opinion{}, ...]

  """
  def list_opinions do
    Repo.all(Opinion)
  end

  @doc """
  Gets a single opinion.

  Raises `Ecto.NoResultsError` if the Opinion does not exist.

  ## Examples

      iex> get_opinion!(123)
      %Opinion{}

      iex> get_opinion!(456)
      ** (Ecto.NoResultsError)

  """
  def get_opinion!(id), do: Repo.get!(Opinion, id)

  @doc """
  Creates a opinion.

  ## Examples

      iex> create_opinion(opinion, %{field: value})
      {:ok, %Opinion{}}

      iex> create_opinion(opinion, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_opinion(attrs \\ %{}) do
    %Opinion{}
    |> opinion_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a opinion.

  ## Examples

      iex> update_opinion(opinion, %{field: new_value})
      {:ok, %Opinion{}}

      iex> update_opinion(opinion, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_opinion(%Opinion{} = opinion, attrs) do
    opinion
    |> opinion_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Opinion.

  ## Examples

      iex> delete_opinion(opinion)
      {:ok, %Opinion{}}

      iex> delete_opinion(opinion)
      {:error, %Ecto.Changeset{}}

  """
  def delete_opinion(%Opinion{} = opinion) do
    Repo.delete(opinion)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking opinion changes.

  ## Examples

      iex> change_opinion(opinion)
      %Ecto.Changeset{source: %Opinion{}}

  """
  def change_opinion(%Opinion{} = opinion) do
    opinion_changeset(opinion, %{})
  end

  defp opinion_changeset(%Opinion{} = opinion, attrs) do
    opinion
    |> cast(attrs, [:kind])
    |> validate_required([:kind])
  end
end
