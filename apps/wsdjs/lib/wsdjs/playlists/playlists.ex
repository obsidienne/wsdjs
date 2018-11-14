defmodule Wsdjs.Playlists do
  @moduledoc """
  The Happenings context.
  """

  import Ecto.Query, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts.User
  alias Wsdjs.Musics.Song
  alias Wsdjs.Playlists.Playlist
  alias Wsdjs.Reactions.Opinion

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
    |> Repo.preload(cover: :art)
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
  def get_playlist!(id, current_user) do
    current_user
    |> Playlist.scoped()
    |> Repo.get!(id)
  end

  def get_playlist!(id), do: Repo.get!(Playlist, id)

  def get_playlist_by_user(user, current_user) do
    current_user
    |> Playlist.scoped()
    |> where(
      [p],
      p.user_id == ^user.id and (p.type == "playlist" or p.type == "top 5")
    )
    |> Repo.all()
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
  def update_playlist(%Playlist{} = playlist, attrs, %User{}) do
    playlist
    |> Playlist.update_changeset(attrs)
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

  defp update_playlist_stat(playlist_id) do
    IO.inspect(playlist_id)

    query = "
      update playlists p
      set count=(select count(*) from playlist_songs s where p.id=s.playlist_id)
        , cover_id=(select song_id from playlist_songs s where p.id=s.playlist_id order by position LIMIT 1)
      where p.id=#{playlist_id}
    "

    Ecto.Adapters.SQL.query!(Repo, query)
  end

  ###############################################
  #
  # Playlist Songs
  #
  ###############################################
  alias Wsdjs.Playlists.PlaylistSong

  def get_playlist_song!(playlist_song_id, current_user) do
    playlist_song = Repo.get!(PlaylistSong, playlist_song_id)

    current_user
    |> Playlist.scoped()
    |> Repo.get!(playlist_song.playlist_id)

    playlist_song
  end

  @doc """
  Returns the first 5 playlist songs in a front page playlists.

  ## Examples

      iex> list_frontpage_playlist_songs(%User{} = user)
      [%Playlist{playlist_song: [songs: []]}, ...]

  """
  def list_frontpage_playlist_songs(current_user) do
    query =
      from(ps in PlaylistSong,
        where: ps.position <= 5,
        preload: [song: :art],
        order_by: ps.position
      )

    current_user
    |> Playlist.scoped()
    |> where([p], p.front_page == true)
    |> Repo.all()
    |> Repo.preload(playlist_songs: query)
  end

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

    query |> Repo.all() |> Repo.preload(:art)
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

    query |> Repo.all() |> Repo.preload(:art)
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

    query |> Repo.all() |> Repo.preload(:art)
  end

  def list_playlist_songs(%Playlist{id: id, type: "top 5"}, current_user) do
    {:ok, playlist_id} = Wsdjs.HashID.dump(id)

    query =
      from(
        ps in PlaylistSong.scoped(current_user),
        where: ps.playlist_id == ^playlist_id,
        order_by: ps.position
      )

    query |> Repo.all() |> Repo.preload(song: :art)
  end

  @doc """
  Add a song to a playlist. It refreshes the song position after insert.

  ## Examples

      iex> create_playlist_song(%{field: value})
      {:ok, %PlaylistSong{}}

      iex> create_playlist_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_playlist_song(attrs \\ %{}) do
    {:ok, playlist_id} = Wsdjs.HashID.dump(Map.get(attrs, :playlist_id))

    %PlaylistSong{}
    |> PlaylistSong.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, %PlaylistSong{} = new_ps} ->
        from(ps in PlaylistSong, where: ps.playlist_id == ^playlist_id and ps.id != ^new_ps.id)
        |> Repo.update_all(inc: [position: 1])

        sort_playlist_song(playlist_id)
        update_playlist_stat(playlist_id)
        {:ok, new_ps}

      default ->
        default
    end
  end

  def update_playlist_song(%PlaylistSong{position: pos} = ps, "up") when pos > 0 do
    down =
      PlaylistSong
      |> Repo.get_by!(playlist_id: ps.playlist_id, position: pos - 1)
      |> PlaylistSong.changeset(%{position: pos})

    up =
      ps
      |> PlaylistSong.changeset(%{position: pos - 1})

    do_switch(ps, down, up)
  end

  def update_playlist_song(%PlaylistSong{position: pos} = ps, "down") do
    up =
      PlaylistSong
      |> Repo.get_by!(playlist_id: ps.playlist_id, position: pos + 1)
      |> PlaylistSong.changeset(%{position: pos})

    down =
      ps
      |> PlaylistSong.changeset(%{position: pos + 1})

    do_switch(ps, down, up)
  end

  defp do_switch(current, down, up) do
    ret =
      Ecto.Multi.new()
      |> Ecto.Multi.update(:up, up)
      |> Ecto.Multi.update(:down, down)
      |> Repo.transaction()
      |> case do
        {:ok, _} -> {:ok, current}
        {:error, _, _, _} -> {:error, current}
      end

    {:ok, playlist_id} = Wsdjs.HashID.dump(current.playlist_id)

    sort_playlist_song(playlist_id)
    update_playlist_stat(playlist_id)
    ret
  end

  @doc """
  Deletes a Playlist song.

  ## Examples

      iex> delete_playlist_song(playlist_song)
      {:ok, %PlaylistSong{}}

      iex> delete_playlist(playlist_song)
      {:error, %Ecto.Changeset{}}

  """
  def delete_playlist_song(%PlaylistSong{} = playlist_song) do
    {:ok, ps} = Repo.delete(playlist_song)
    {:ok, playlist_id} = Wsdjs.HashID.dump(ps.playlist_id)

    sort_playlist_song(playlist_id)
    update_playlist_stat(playlist_id)

    {:ok, ps}
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking playlist song changes.

  ## Examples

      iex> change_playlist_song(playlist_song)
      %Ecto.Changeset{source: %PlaylistSong{}}

  """
  def change_playlist_song(%PlaylistSong{} = playlist_song) do
    PlaylistSong.changeset(playlist_song, %{})
  end

  defp sort_playlist_song(playlist_id) do
    query =
      from(
        ps in PlaylistSong,
        join:
          r in fragment("""
          SELECT id, playlist_id, row_number() OVER (
            PARTITION BY playlist_id
            ORDER BY position
          ) as rn FROM playlist_songs
          """),
        where: ps.playlist_id == ^playlist_id and ps.id == r.id,
        select: %{id: ps.id, pos: r.rn}
      )

    query
    |> Repo.all()
    |> Enum.each(fn rank ->
      # credo:disable-for-lines:2
      from(ps in PlaylistSong, where: [id: ^rank.id])
      |> Repo.update_all(set: [position: rank.pos])
    end)
  end
end
