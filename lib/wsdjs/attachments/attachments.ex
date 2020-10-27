defmodule Wsdjs.Attachments do
  @moduledoc """
  The boundary for the Attachments system.
  """

  import Ecto.Query, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Attachments.Videos.Video
  alias Wsdjs.Songs.Song

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Videox@x@ does not exist.

  ## Examples

      iex> get_video!(123)
      %Comment{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id), do: Repo.get!(Video, id)

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos(%Song{})
      [%Video{}, ...]
  """
  def list_videos(%Song{id: id}) do
    Video
    |> where(song_id: ^id)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(params) do
    %Video{}
    |> Video.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{source: %Video{}}

  """
  def change_video(%Video{} = video) do
    Video.changeset(video, %{})
  end

  @doc """
  Deletes a Video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  ###############################################
  #
  # Avatar
  #
  ###############################################
  alias Wsdjs.Accounts.User
  alias Wsdjs.Attachments.Avatars.Avatar

  @doc """
  Returns the user avatar.

  ## Examples

      iex> get_avatar(%User{})
      %Avatar{}
  """
  def get_avatar(%User{id: id}) do
    Avatar
    |> where(user_id: ^id)
    |> order_by(desc: :inserted_at)
    |> limit(1)
    |> Repo.all()
  end
end
