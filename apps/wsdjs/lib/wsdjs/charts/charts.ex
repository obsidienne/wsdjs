defmodule Wsdjs.Charts do
  @moduledoc """
  The boundary for the Charts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo
  alias Ecto.Changeset

  alias Wsdjs.Charts.{Top, Rank, Vote}
  alias Wsdjs.Musics.Song
  alias Wsdjs.Accounts.User

  @doc """
  Returns the current user's last accessible published Top.
  """
  def last_top(current_user) do
    current_user
    |> Top.scoped()
    |> order_by([desc: :due_date])
    |> where(status: "published")
    |> limit(1)
    |> Repo.one
    |> Repo.preload(ranks: list_rank())
    |> Repo.preload(ranks: :song)
    |> Repo.preload(ranks: [song: :art])
    |> Repo.preload(ranks: [song: [user: :avatar]])
  end

  @doc """
  Returns Tops accessible for the current user.
  """
  def paginate_tops(current_user, paginate_params \\ %{}) do
    tops = current_user
    |> Top.scoped()
    |> order_by([desc: :due_date])
    |> Repo.paginate(paginate_params)

    entries = tops.entries
    |> Repo.preload(ranks: list_rank())
    |> Repo.preload(:songs)

    %{
      "entries": entries,
      "total_pages": tops.total_pages,
      "page_number": tops.page_number
    }
  end

  def stat_top!(current_user, top_id) do
    current_user
    |> Top.scoped()
    |> Repo.get(top_id)
    |> Repo.preload([:songs, :votes])
    |> Repo.preload(ranks: list_rank())
    |> Repo.preload(ranks: :song)
    |> Repo.preload(ranks: [song: :art])
    |> Repo.preload(ranks: [song: [user: :avatar]])
  end

  @doc """
  Gets a single top.

  Raises `Ecto.NoResultsError` if the Top does not exist.

  ## Examples

      iex> get_top!(123)
      %Top{}

      iex> get_top!(456)
      ** (Ecto.NoResultsError)

  """
  def get_top!(id), do: Repo.get!(Top, id)

  def create_top(params) do
    due_date = Timex.to_datetime(Map.fetch!(params, :due_date))
    start_period = Timex.beginning_of_month(due_date)
    end_period = Timex.end_of_month(due_date)
    query = from s in Song, where: s.inserted_at >= ^start_period and s.inserted_at <= ^end_period
    songs = Repo.all(query)

    %Top{}
    |> Top.changeset(Map.put(params, :status, "checking"))
    |> put_assoc(:songs, songs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Top.

  ## Examples

      iex> delete_top(top)
      {:ok, %Top{}}

      iex> delete_top(top)
      {:error, %Ecto.Changeset{}}

  """
  def delete_top(%Top{} = top) do
    Repo.delete(top)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking top changes.

  ## Examples

      iex> change_top(top)
      %Ecto.Changeset{source: %Top{}}

  """
  def change_top(%Top{} = top) do
    Top.changeset(top, %{})
  end

  ###############################################
  #
  # Change TOP step
  #
  ###############################################
  # Change the top status.
  # The steps are the following : check -> vote -> count -> publish
  # The step create does not use this function.
  def next_step(top) do
    %{checking: "voting",
      voting: "counting",
      counting: "published"}
    |> Map.fetch!(String.to_atom(top.status))
    |> go_step(top)
  end

  # Change the top status.
  # The steps are the following : check -> vote -> count -> publish
  # The step create does not use this function.
  def previous_step(top) do
    %{published: "counting",
      counting: "voting"}
    |> Map.fetch!(String.to_atom(top.status))
    |> go_step(top)
  end

  # The top creator is ok with the songs in the top. The top creator freeze the likes
  # according to this rule: (like * 2) - (down * 3) + (up * 4)
  # After that, DJs can vote for their top 10.
  defp go_step("voting", top) do
    top
    |> Top.step_changeset(%{status: "voting"})
    |> Repo.update()
  end

  # The top creator decides it's time to stop voting
  # we reinitialize the total votes and likes (admin can return from published)
  # Need to sum the votes according to this rule
  # vote = 10 * (nb vote for song) - (total vote position for song) + (nb vote for song)
  # After that, the top creator can apply bonus to the top.
  defp go_step("counting", top) do
    from(p in Wsdjs.Charts.Rank, where: [top_id: ^top.id])
    |> Repo.update_all(set: [votes: 0, likes: 0, position: nil])

    set_likes(top)
    set_votes(top)

    top
    |> Top.step_changeset(%{status: "counting"})
    |> Repo.update()
  end

  # Need to calculate the position according to likes + votes + bonus.
  defp go_step("published", top) do
    query = from q in Rank,
      join: p in fragment("""
      SELECT id, top_id, row_number() OVER (
        PARTITION BY top_id
        ORDER BY votes + bonus + likes DESC
      ) as rn FROM ranks
      """),
    where: q.top_id == ^top.id and p.id == q.id,
    select: %{id: q.id, pos: p.rn}

    query
    |> Repo.all()
    |> Enum.each(fn(rank) ->
      from(p in Wsdjs.Charts.Rank, where: [id: ^rank.id])
      |> Repo.update_all(set: [position: rank.pos])
    end)

    top
    |> Top.step_changeset(%{status: "published"})
    |> Repo.update()
  end

  ###############################################
  #
  # Vote
  #
  ###############################################

  def list_votes(%Top{} = top) do
    Vote
    |> where(top_id: ^top.id)
    |> Repo.all()
  end

  defp q_list_votes(id, %User{} = user) do
    Vote
    |> where([user_id: ^user.id, top_id: ^id])
  end

  def list_votes(%Top{}, nil), do: []
  def list_votes(%Top{id: id}, %User{} = user) do
    id
    |> q_list_votes(user)
    |> Repo.all()
  end

  def vote(user, %{"top_id" => top_id, "votes" => votes_param}) do
    top = get_top!(top_id)
    top = Repo.preload top, votes: q_list_votes(top_id, user)

    new_votes = votes_param
                |> Map.keys()
                |> Enum.reject(fn(v) -> votes_param[v] == "" end)
                |> Enum.map(&Vote.get_or_build(top, user.id, &1, votes_param[&1]))

    top
    |> Changeset.change
    |> Changeset.put_assoc(:votes, new_votes)
    |> Repo.update()
  end

  ###############################################
  #
  # Rank
  #
  ###############################################

  def set_bonus(rank_id, bonus) do
    rank = Repo.get!(Rank, rank_id)

    rank
    |> Rank.changeset(%{bonus: bonus})
    |> Repo.update()
  end

  def set_likes(%Top{id: id}) do
    ranks = Rank
    |> where(top_id: ^id)
    |> preload(song: :opinions)
    |> Repo.all()

    Enum.each(ranks, fn(rank) ->
      val = Wsdjs.Musics.opinions_value(rank.song.opinions)
      rank
      |> Rank.changeset(%{likes: val})
      |> Repo.update()
    end)
  end

  def set_votes(%Top{id: id}) do
    Wsdjs.Charts.Vote
    |> where(top_id: ^id)
    |> group_by(:song_id)
    |> select([v], %{song_id: v.song_id, count: count(v.song_id), sum: sum(v.votes)})
    |> Repo.all()
    |> Enum.each(fn(vote) ->
      val = 10 * vote[:count] - vote[:sum] + vote[:count]
      from(p in Wsdjs.Charts.Rank, where: [top_id: ^id, song_id: ^vote.song_id])
      |> Repo.update_all(set: [votes: val])
    end)
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
    Rank.changeset(rank, %{})
  end

  @doc """
  When a nil user can only access published top with a limit of 10 songs order by position.
  A published top always contains position.
  """
  def list_rank(nil, %Top{status: "published"} = top) do
    top
    |> list_rank()
    |> order_by([r], asc: r.position)
    |> limit(10)
    |> Repo.all()
  end
  def list_rank(%User{}, %Top{status: "published"} = top) do
    top
    |> list_rank()
    |> order_by([r], desc: fragment("? + ? + ?", r.votes, r.bonus, r.likes))
    |> Repo.all()
  end
  def list_rank(%User{admin: true}, %Top{status: "counting"} = top) do
    top
    |> list_rank()
    |> order_by([r], desc: fragment("? + ? + ?", r.votes, r.bonus, r.likes))
    |> Repo.all()
  end
  def list_rank(%User{admin: true}, %Top{status: "checking"} = top) do
    top
    |> list_rank()
    |> order_by([r], desc: :inserted_at)
    |> Repo.all()
  end

  def list_rank(%User{} = current_user, %Top{id: top_id, status: "voting"}) do
    votes = from v in Vote, where: [user_id: ^current_user.id, top_id: ^top_id]

    query = from r in Rank,
    where: r.top_id == ^top_id,
    left_join: v in ^votes, on: [song_id: r.song_id],
    order_by: [asc: v.votes, desc: :inserted_at],
    preload: [song: [:art, :user, :opinions]]

    Repo.all query
  end

  defp list_rank(%Top{id: id}) do
    from r in Rank,
    where: r.top_id == ^id,
    preload: [song: [:art, :user, :opinions]]
  end

  def list_rank do
    from q in Rank,
    where: q.position <= 10,
    order_by: [asc: q.position],
    preload: [song: :art]
  end
end
