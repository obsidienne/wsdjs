defmodule Wsdjs.Attachments do
  @moduledoc """
  Documentation for Attachments.
  """

  @base_url ~S(https://res.cloudinary.com/)
  @cloud_name ~S(don2kwaju)
  @cld_https "https://res.cloudinary.com/don2kwaju/image/upload/"
  @cld_youtube "https://res.cloudinary.com/don2kwaju/image/youtube/"
  @dpr_multiple [1, 2, 3]

  def process_url(url), do: "#{@base_url}/#{@cloud_name}/#{url}"
  ###############################################
  #
  # VIDEO THUMBNAIL
  #
  ###############################################
  def thumbnail_url(%{video_id: video_id, provider: "youtube"}, resolution)
      when is_integer(resolution) do
    @cld_youtube <> "c_fit,f_auto,w_#{resolution},q_auto/fl_immutable_cache/" <> "#{video_id}.jpg"
  end

  def thumbnail_url(%{provider: "facebook"}, resolution) when is_integer(resolution) do
    @cld_https <> "c_fit,f_auto,w_#{resolution},q_auto/fl_immutable_cache/v1/wsdjs/facebook.jpg"
  end

  def thumbnail_url(%{}, resolution) when is_integer(resolution) do
    @cld_https <>
      "c_fit,f_auto,w_#{resolution},q_auto/fl_immutable_cache/v1/wsdjs/missing_cover.jpg"
  end

  def thumbnail_srcset(%{} = video, base) when is_integer(base) do
    resolutions = Enum.map(@dpr_multiple, &(base * &1))

    resolutions
    |> Enum.map(fn r -> "#{thumbnail_url(video, r)} #{r}w" end)
    |> Enum.join(", ")
  end

  import Ecto.{Query, Changeset}, warn: false

  alias Wsdjs.Repo
  alias Wsdjs.Attachments.Videos.Video
  alias Wsdjs.Musics.Song

  def can?(%Wsdjs.Accounts.User{admin: true}, _, _), do: :ok
  def can?(%Wsdjs.Accounts.User{id: id}, :delete, %Video{user_id: id}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%Wsdjs.Accounts.User{admin: true}, _), do: :ok
  def can?(_, _), do: {:error, :unauthorized}

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
end
