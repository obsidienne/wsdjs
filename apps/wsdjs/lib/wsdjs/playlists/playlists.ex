defmodule Wsdjs.Playlists do
  @moduledoc """
  The Happenings context.
  """

  import Ecto.Query, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Musics.Song
  alias Wsdjs.Reactions.Opinion
  alias Wsdjs.Playlists.Playlist

  @doc """
  Returns the list of playlists.

  ## Examples

      iex> list_playlists()
      [%Playlist{}, ...]

  """
  def list_playlists(%Wsdjs.Accounts.User{id: id}) do
    query = from p in Playlist, 
    where: p.user_id == ^id,
    order_by: [desc: :inserted_at]

    Repo.all(query) |> Repo.preload(song: :art)
  end

  @doc """
  Gets a single playlist.

  Raises `Ecto.NoResultsError` if the Playlist does not exist.

  ## Examples

      iex> get_playlist!(123, user)
      %Playlist{}

      iex> get_playlist!(456, user)
      ** (Ecto.NoResultsError)

  """
  def get_playlist!(id, %Wsdjs.Accounts.User{} = user) do
    query = from p in Playlist, where: p.user_id == ^user.id 

    Repo.get!(query, id)
  end
  def get_playlist!(id), do: Repo.get!(Playlist, id)


  @doc """
  Creates a playlist.

  ## Examples

      iex> create_playlist(%{field: value})
      {:ok, %Playlist{}}

      iex> create_playlist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_playlist(attrs \\ %{}) do
    %Playlist{}
    |> Playlist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a playlist.

  ## Examples

      iex> update_playlist(playlist, %{field: new_value})
      {:ok, %Playlist{}}

      iex> update_playlist(playlist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_playlist(%Playlist{} = playlist, attrs) do
    playlist
    |> Playlist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Playlist.

  ## Examples

      iex> delete_playlist(playlist)
      {:ok, %Playlist{}}

      iex> delete_playlist(playlist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_playlist(%Playlist{} = playlist) do
    Repo.delete(playlist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking playlist changes.

  ## Examples

      iex> change_playlist(playlist)
      %Ecto.Changeset{source: %Playlist{}}

  """
  def change_playlist(%Playlist{} = playlist) do
    Playlist.changeset(playlist, %{})
  end

  ###############################################
  #
  # Playlist Songs
  #
  ###############################################
  alias Ecto.Changeset
  alias Wsdjs.Accounts.User
  alias Wsdjs.Playlists.PlaylistSong

  @doc """
  Returns the list of list_playlist_songs.

  ## Examples

      iex> list_playlist_songs(%Playlist{id: id})
      [%Song{}, ...]

  """
  def list_playlist_songs(%Playlist{id: id, type: "suggested", user_id: user_id}, %User{} = current_user) do
    query = from s in Song.scoped(current_user),
    where: s.user_id == ^user_id,  
    order_by: [desc: s.inserted_at]

    Repo.all(query) |> Repo.preload(:art)
  end

  def list_playlist_songs(%Playlist{id: id, type: "likes and tops", user_id: user_id}, %User{} = current_user) do
    query = from s in Song.scoped(current_user),
    join: o in Opinion, on: o.song_id == s.id,
    where: o.user_id == ^user_id,
    order_by: [desc: o.updated_at]

    Repo.all(query) |> Repo.preload(:art)
  end

  def list_playlist_songs(%Playlist{id: id, type: "playlist", user_id: user_id}, %User{} = current_user) do
    query = from s in Song.scoped(current_user),
    join: ps in PlaylistSong, on: ps.playlist_id == ^id and ps.song_id == s.id,
    order_by: ps.position

    Repo.all(query) |> Repo.preload(:art)
  end

  def update_playlist_songs(%Playlist{} = playlist, song_positions) do
    playlist = playlist |> Repo.preload(:playlist_songs)

    songs = song_positions
            |> Map.keys()
            |> Enum.reject(fn(v) -> song_positions[v] == "" end)
            |> Enum.map(&PlaylistSong.get_or_build(playlist, &1, song_positions[&1]))

    playlist
    |> Changeset.change
    |> Changeset.put_assoc(:playlist_songs, songs)
    |> Repo.update()
  end
end
