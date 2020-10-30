defmodule Wsdjs.Songs do
  @moduledoc """
  The boundary for the Music system.
  """

  import Ecto.Query, warn: false
  alias Wsdjs.Repo

  alias Wsdjs.Accounts
  alias Wsdjs.Accounts.User
  alias Wsdjs.Songs.Song
  alias Wsdjs.Songs

  @doc """
  The scope rules are
    - admin can access any songs
  """
  def scoped(%Accounts.User{admin: true}), do: Song
  def scoped(%Accounts.User{profil_djvip: true}), do: Song

  def scoped(%Accounts.User{profil_dj: true} = user) do
    upper = Timex.shift(Timex.beginning_of_month(Timex.now()), months: -3)
    lower = Timex.shift(upper, months: -24)

    # credo:disable-for-lines:2
    scoped(lower, upper)
    |> or_where([s], s.user_id == ^user.id)
  end

  def scoped(%Accounts.User{} = user) do
    upper = Timex.shift(Timex.beginning_of_month(Timex.now()), months: -3)
    lower = Timex.shift(upper, months: -12)

    # credo:disable-for-lines:2
    scoped(lower, upper)
    |> or_where([s], s.user_id == ^user.id)
  end

  def scoped(nil) do
    lower = Timex.shift(Timex.beginning_of_month(Timex.now()), months: -6)
    upper = Timex.shift(Timex.beginning_of_month(Timex.now()), months: -3)

    scoped(lower, upper)
  end

  defp scoped(%DateTime{} = lower, %DateTime{} = upper) do
    from(
      s in Songs.Song,
      left_join: r in assoc(s, :ranks),
      left_join: t in assoc(r, :top),
      where:
        (t.status == "published" and r.position <= 10 and t.due_date >= ^lower and
           t.due_date <= ^upper) or s.instant_hit == true or s.public_track == true
    )
  end

  @doc """
  The policies are
    - admin can do anything
    - user can do anything to his own song
  """
  def can?(%User{admin: true}, _, _), do: :ok
  def can?(%User{id: id}, _, %Song{user_id: id}), do: :ok
  def can?(_, :show, %Song{public_track: true}), do: :ok
  def can?(_, :show, %Song{instant_hit: true}), do: :ok
  def can?(%User{profil_djvip: true}, :show, %Song{hidden_track: true}), do: :ok

  def can?(user, :show, %Song{id: id}) do
    song = Repo.get(Songs.scoped(user), id)

    case song do
      %Song{} -> :ok
      nil -> {:error, :unauthorized}
    end
  end

  def can?(_, _, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _), do: :ok
  def can?(%User{profil_djvip: true}, :suggest), do: :ok
  def can?(%User{admin: true}, :create), do: :ok
  def can?(%User{}, :search), do: :ok
  def can?(%User{}, :list_user_suggestions), do: :ok

  def can?(_, _), do: {:error, :unauthorized}

  def instant_hits do
    Song
    |> where(instant_hit: true)
    |> preload([:art, user: :user_profil, comments: :user, opinions: :user])
    |> order_by(desc: :inserted_at)
    |> limit(6)
    |> Repo.all()
  end

  def list_songs(%User{} = user, criteria) when is_list(criteria) do
    query = Songs.scoped(user)

    # query = from(d in Song)

    Enum.reduce(criteria, query, fn
      {:paginate, %{page: page, per_page: per_page}}, query ->
        from q in query,
          offset: ^((page - 1) * per_page),
          limit: ^per_page

      {:sort, %{sort_by: sort_by, sort_order: sort_order}}, query ->
        from q in query, order_by: [{^sort_order, ^sort_by}]

      {:query, %{q: ""}}, query ->
        query

      {:query, %{q: q}}, query ->
        q =
          q
          |> String.trim()
          |> String.split(" ")
          |> Enum.map(&"#{&1}:*")
          |> Enum.join(" & ")

        query
        |> where(
          fragment(
            "(to_tsvector('english', coalesce(artist, '') || ' ' ||  coalesce(title, '')) @@ to_tsquery('english', ?))",
            ^q
          )
        )
    end)
    |> preload([:art])
    |> Repo.all()
  end

  def count_songs(%User{} = user), do: Repo.aggregate(Songs.scoped(user), :count, :id)

  @doc """
  Returns the songs added the 24 last hours.
  """
  def list_songs(%DateTime{} = lower, %DateTime{} = upper) when lower < upper do
    query = from(s in Song, where: s.inserted_at >= ^lower and s.inserted_at <= ^upper)

    Repo.all(query)
  end

  @doc """
  Returns the songs filtered by facets.
  """
  def list_songs(%User{} = user) do
    user
    |> Songs.scoped()
    |> where([s], s.suggestion == true)
    |> order_by(desc: :inserted_at)
    |> preload([:art, user: :user_profil, comments: :user, opinions: :user])
    |> limit(15)
    |> Repo.all()
  end

  def bpm_ranges do
    %{
      "vs" => 1..69,
      "s" => 70..89,
      "m" => 90..109,
      "f" => 110..129,
      "vf" => 130..9999
    }
  end

  def list_suggested_songs(%DateTime{} = lower, %DateTime{} = upper) when lower < upper do
    query =
      from(
        s in Song,
        where: s.inserted_at >= ^lower and s.inserted_at <= ^upper and s.suggestion == true
      )

    Repo.all(query)
  end

  def preload_songs(tops) when is_list(tops), do: Repo.preload(tops, :songs)

  @doc """
  Creates a song.

  ## Examples

      iex> create_song(%{field: value})
      {:ok, %Song{}}

      iex> create_song(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_song(params) do
    %Song{}
    |> Song.create_changeset(params)
    |> Repo.insert()
  end

  @doc """
  Creates a suggestion.

  ## Examples

      iex> create_suggestion(%{field: value})
      {:ok, %Song{}}

      iex> create_suggestion(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_suggestion(params) do
    %Song{}
    |> Song.suggestion_changeset(params)
    |> Repo.insert()
  end

  @doc """
  Gets a single song.

  Raises `Ecto.NoResultsError` if the Song does not exist.

  ## Examples

      iex> get_song!(123)
      %Song{}

      iex> get_song!(456)
      ** (Ecto.NoResultsError)

  """
  def get_song!(id, to_preload \\ [:art, :user]) do
    Song
    |> Repo.get!(id)
    |> Repo.preload(to_preload)
  end

  @doc """
  Get the song matching the "artist - title" pattern.
  The uniq index artist / title ensure the uniquenes of result.
  This a privileged function, no song restriction access.
  """
  def get_song_by(artist, title) when is_binary(artist) and is_binary(title) do
    Song
    |> where([s], fragment("lower(?)", s.title) == ^String.downcase(title))
    |> where([s], fragment("lower(?)", s.artist) == ^String.downcase(artist))
    |> preload([:user, :art])
    |> preload(tops: :ranks)
    |> Repo.one()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking song changes.

  ## Examples

      iex> change_song(song)
      %Ecto.Changeset{source: %Song{}}

  """
  def change(%Song{} = song) do
    Song.update_changeset(song, %{})
  end

  @doc """
  Updates a song.

  ## Examples

      iex> update(song, %{field: new_value}, %User{})
      {:ok, %Song{}}

      iex> update(song, %{field: bad_value}, %User{})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Song{} = song, attrs, %User{admin: false}) do
    song
    |> Song.update_changeset(attrs)
    |> Repo.update()
  end

  def update(%Song{} = song, attrs, %User{admin: true}) do
    song
    |> Song.admin_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Song.

  ## Examples

      iex> delete(song)
      {:ok, %Song{}}

      iex> delete(song)
      {:error, %Ecto.Changeset{}}

  """
  def delete(%Song{} = song) do
    Repo.delete(song)
  end
end
