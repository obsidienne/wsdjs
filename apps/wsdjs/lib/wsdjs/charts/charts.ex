defmodule Wsdjs.Charts do
  @moduledoc """
  The boundary for the Charts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Wsdjs.Repo
  alias Ecto.Changeset

  alias Wsdjs.Charts
  alias Wsdjs.Charts.{Top, Rank, Vote, Policy}
  alias Wsdjs.Musics
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

  def get_top!(current_user, top_id) do
    current_user
    |> Top.scoped()
    |> Repo.get!(top_id)
    |> Repo.preload(:user)
    |> Repo.preload(ranks: list_rank(current_user, top_id))
  end

  def create_top(%{"due_date" => due_date} = params) do
    start_period = Timex.to_datetime(Timex.beginning_of_month(due_date))
    end_period = Timex.to_datetime(Timex.end_of_month(due_date))
    query = from s in Song, where: s.inserted_at >= ^start_period and s.inserted_at <= ^end_period
    songs = Repo.all(query)

    %Top{}
    |> Top.changeset(params)
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

  ###############################################
  #
  # Change TOP step
  #
  ###############################################
  # Change the top status.
  # The steps are the following : check -> vote -> count -> publish
  # The step create does not use this function.
  def next_step(%User{} = _user, top) do
    %{checking: "voting",
      voting: "counting",
      counting: "published"}
    |> Map.fetch!(String.to_atom(top.status))
    |> go_step(top)
  end

  # Change the top status.
  # The steps are the following : check -> vote -> count -> publish
  # The step create does not use this function.
  def previous_step(%User{} = user, top) do
    %{published: "counting",
      counting: "voting"}
    |> Map.fetch!(String.to_atom(top.status))
    |> go_step(top)
  end

  # The top creator is ok with the songs in the top. The top creator freeze the likes
  # according to this rule: (like * 2) - (down * 3) + (up * 4)
  # After that, DJs can vote for their top 10.
  defp go_step("voting", top) do
    ranks = Rank
    |> where(top_id: ^top.id)
    |> preload(song: :opinions)
    |> Repo.all()

    Enum.each(ranks, fn(rank) ->
      val = Enum.reduce(rank.song.opinions, 0, fn(opinion, acc) ->
        case opinion.kind do
          "up"   -> acc + 4
          "like" -> acc + 2
          "down" -> acc - 3
          _      -> acc
        end
      end)

      rank
      |> Rank.changeset(%{likes: val})
      |> Repo.update()
    end)

    top
    |> Top.step_changeset(%{status: "voting"})
    |> Repo.update()
  end

  # The top creator decides it's time to publish the
  # Need to sum the votes according to this rule
  # vote = 10 * (nb vote for song) - (total vote position for song) + (nb vote for song)
  # After that, the top creator can apply bonus to the top.
  defp go_step("counting", top) do
    from(p in Wsdjs.Charts.Rank, where: [top_id: ^top.id])
    |> Repo.update_all(set: [votes: 0])

    Wsdjs.Charts.Vote
    |> where(top_id: ^top.id)
    |> group_by(:song_id)
    |> select([v], %{song_id: v.song_id, count: count(v.song_id), sum: sum(v.votes)})
    |> Repo.all()
    |> Enum.each(fn(vote) ->
      val = 10 * vote[:count] - vote[:sum] + vote[:count]
      from(p in Wsdjs.Charts.Rank, where: [top_id: ^top.id, song_id: ^vote.song_id])
      |> Repo.update_all(set: [votes: val])
    end)

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

  def list_votes(id, %User{} = user) do
    id
    |> q_list_votes(user)
    |> Repo.all()
  end

  def vote(user, %{"top_id" => top_id, "votes" => votes_param}) do
    top = get_top!(user, top_id)
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

  @doc """
  Gets a single rank.

  Raises `Ecto.NoResultsError` if the Rank does not exist.

  ## Examples

      iex> get_rank!("0f47da03-0a18-421d-b614-a84861c28f45")
      %Rank{}

      iex> get_rank!("8dfbdd61-4464-4e43-863b-52f13c44326b")
      ** (Ecto.NoResultsError)

  """
  def get_rank!(id) do
    Rank
    |> Repo.get!(id)
  end

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

  defp list_rank(current_user, top_id) do
    current_user_votes = from v in Vote, where: [user_id: ^current_user.id, top_id: ^top_id]

    from r in Rank,
    where: r.top_id == ^top_id,
    left_join: v in ^current_user_votes, on: [song_id: r.song_id],
    order_by: [asc: r.position, asc: v.votes, desc: fragment("? + ? + ?", r.votes, r.bonus, r.likes)],
    preload: [song: [:art, :user, :opinions]]
  end

  defp list_rank do
    from q in Rank,
    where: q.position <= 10,
    order_by: [asc: q.position],
    preload: [song: :art]
  end
end
