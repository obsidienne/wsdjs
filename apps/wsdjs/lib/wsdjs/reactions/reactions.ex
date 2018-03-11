defmodule Wsdjs.Reactions do
  @moduledoc """
  The boundary for the Reaction system.
  """
  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo

  ###############################################
  #
  # Comment
  #
  ###############################################
  alias Wsdjs.Reactions.Comment
  alias Wsdjs.Musics.Song

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments(%Song{})
      [%Comment{}, ...]
  """
  def list_comments(%Song{id: id}) do
    Comment
    |> where(song_id: ^id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload(user: :avatar)
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(params) do
    {:ok, comment} =
      %Comment{}
      |> Comment.changeset(params)
      |> Repo.insert()

    {:ok, Repo.preload(comment, user: :avatar)}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{source: %Comment{}}

  """
  def change_comment(%Comment{} = comment) do
    Comment.changeset(comment, %{})
  end

  @doc """
  Deletes a Comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  ###############################################
  #
  # Opinion
  #
  ###############################################
  alias Wsdjs.Musics.Song
  alias Wsdjs.Accounts.User
  alias Wsdjs.Reactions.Opinion

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
  Gets a single opinion by parameters.

  Raises `Ecto.NoResultsError` if the Opinion does not exist.

  ## Examples

      iex> get_opinion!(params)
      %Opinion{}

      iex> get_opinion!(not_matching_params)
      ** (Ecto.NoResultsError)

  """
  def get_opinion_by(params), do: Repo.get_by(Opinion, params)

  @doc """
  Gets the opinion total value of opinions list.

  ## Examples

      iex> opinions_value([%{kind: "up"}, %{kind: "down"}, %{kind: "like"}])
      3

  """
  def opinions_value(opinions) when is_list(opinions) do
    Enum.reduce(opinions, 0, fn opinion, acc ->
      case opinion.kind do
        "up" -> acc + 4
        "like" -> acc + 2
        "down" -> acc - 3
        _ -> acc
      end
    end)
  end

  @doc """
  List opinions for a song

    ## Examples

      iex> list_opinions(%Song{})
      [%Opinion{}, ...]
  """
  def list_opinions(%Song{id: id}) do
    Opinion
    |> where(song_id: ^id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> Repo.preload(user: :avatar)
  end

  @doc """
  Deletes an Opinion.

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
    Opinion.changeset(opinion, %{})
  end

  @doc """
  Update or create an opinion.

  """
  def upsert_opinion(%User{id: user_id}, %Song{id: song_id}, kind) do
    opinion =
      case get_opinion_by(user_id: user_id, song_id: song_id) do
        nil -> %Opinion{kind: kind, user_id: user_id, song_id: song_id}
        song_opinion -> song_opinion
      end

    opinion
    |> Opinion.changeset(%{kind: kind})
    |> Repo.insert_or_update()
  end
end
