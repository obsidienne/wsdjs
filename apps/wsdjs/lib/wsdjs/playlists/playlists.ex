defmodule Wsdjs.Playlists do
  @moduledoc """
  The Happenings context.
  """

  import Ecto.Query, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Musics.Song
  alias Wsdjs.Reactions.Opinion
  alias Wsdjs.Playlists.Playlist
  alias Wsdjs.Accounts.User

  @doc """
  Returns the list of playlists.

  ## Examples

      iex> list_playlists()
      [%Playlist{}, ...]

  """
  def list_playlists(%User{id: id}, current_user) do
    current_user
    |> Playlist.scoped()
    |> where(user_id: ^id)
    |> Repo.all()
    |> Repo.preload(song: :art)
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
  def get_playlist!(id, user, current_user) do
    current_user
    |> Playlist.scoped()
    |> where(user_id: ^user.id)
    |> Repo.get!(id)
  end

  def get_playlist!(id), do: Repo.get!(Playlist, id)

  def get_playlist_by_user(user, current_user) do
    current_user
    |> Playlist.scoped()
    |> Repo.get_by(user_id: user.id, type: "likes and tops")
  end

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
    |> Playlist.update_changeset(attrs)
    |> Repo.update()
  end

  def toggle_playlist_visibiliy(%User{} = user, attrs, %User{} = current_user) do
    playlist = get_playlist_by_user(user, current_user)
    bool = get_in(attrs, ["parameter", "public_top_like"])

    case playlist do
      nil -> {:ok, playlist}
      _ -> update_playlist(playlist, %{"public" => bool})
    end
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

      iex> list_playlist_songs(%Playlist{id: id}, %User{} = user)
      [%Song{}, ...]

  """
  def list_playlist_songs(%Playlist{type: "suggested", user_id: user_id}, current_user) do
    query =
      from(
        s in Song.scoped(current_user),
        where: s.user_id == ^user_id,
        order_by: [desc: s.inserted_at]
      )

    Repo.all(query) |> Repo.preload(:art)
  end

  def list_playlist_songs(%Playlist{type: "likes and tops", user_id: user_id}, current_user) do
    query =
      from(
        s in Song.scoped(current_user),
        join: o in Opinion,
        on: o.song_id == s.id,
        where: o.user_id == ^user_id,
        order_by: [desc: o.updated_at]
      )

    Repo.all(query) |> Repo.preload(:art)
  end

  def list_playlist_songs(%Playlist{id: id, type: "playlist"}, current_user) do
    {:ok, playlist_id} = Wsdjs.HashID.dump(id)

    query =
      from(
        s in Song.scoped(current_user),
        join: ps in PlaylistSong,
        on: ps.playlist_id == ^playlist_id and ps.song_id == s.id,
        order_by: ps.position
      )

    Repo.all(query) |> Repo.preload(:art)
  end

  def list_playlist_songs(%Playlist{id: id, type: "top 5"}, current_user) do
    {:ok, playlist_id} = Wsdjs.HashID.dump(id)

    query =
      from(
        s in Song.scoped(current_user),
        join: ps in PlaylistSong,
        on: ps.playlist_id == ^playlist_id and ps.song_id == s.id,
        order_by: ps.position
      )

    Repo.all(query) |> Repo.preload(:art)
  end

  def update_playlist_songs(%Playlist{} = playlist, song_positions) do
    playlist = playlist |> Repo.preload(:playlist_songs)

    songs =
      song_positions
      |> Map.keys()
      |> Enum.reject(fn v -> song_positions[v] == "" end)
      |> Enum.map(&PlaylistSong.get_or_build(playlist, &1, song_positions[&1]))

    playlist
    |> Changeset.change()
    |> Changeset.put_assoc(:playlist_songs, songs)
    |> Repo.update()
  end
end
