defmodule Wsdjs.Reactions.Opinions do
  @moduledoc """
  """
  import Ecto.Query, warn: false

  alias Wsdjs.Accounts.User
  alias Wsdjs.Songs.Song
  alias Wsdjs.Reactions.Opinions.Opinion
  alias Wsdjs.Repo

  @doc """
        The policies of this module are
      - admin can do anything
      - user can delete its own opinion
      - user can create an opinion
      - unauthenticated user is without rights
  """
  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{}, :create, _), do: :ok
  def can?(%User{id: id}, :delete, %Opinion{user_id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  @doc """
  Gets a single opinion.

  Raises `Ecto.NoResultsError` if the Opinion does not exist.

  ## Examples

      iex> get!(123)
      %Opinion{}

      iex> get!(456)
      ** (Ecto.NoResultsError)

  """
  def get!(id), do: Repo.get!(Opinion, id)

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

      iex> list(%Song{})
      [%Opinion{}, ...]
  """
  def list(%Song{id: id}) do
    Opinion
    |> where(song_id: ^id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
    |> load_user()
  end

  @doc """
  Deletes an Opinion.

  ## Examples

      iex> delete(opinion)
      {:ok, %Opinion{}}

      iex> delete(opinion)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Opinion{} = opinion) do
    Repo.delete(opinion)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking opinion changes.

  ## Examples

      iex> change(opinion)
      %Ecto.Changeset{source: %Opinion{}}

  """
  def change(%Opinion{} = opinion) do
    Opinion.changeset(opinion, %{})
  end

  @doc """
  Update or create an opinion.

  """
  def upsert(%User{id: user_id}, %Song{id: song_id}, kind) do
    opinion =
      case Repo.get_by(Opinion, user_id: user_id, song_id: song_id) do
        nil -> %Opinion{kind: kind, user_id: user_id, song_id: song_id}
        song_opinion -> song_opinion
      end

    opinion
    |> Opinion.changeset(%{kind: kind})
    |> Repo.insert_or_update()
  end

  def load_user(opinion) do
    Repo.preload(opinion, user: :user_profil)
  end
end
