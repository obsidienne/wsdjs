defmodule Wcsp.Top do
  use Wcsp.Schema

  schema "tops" do
    field :due_date, :date
    field :status, :string

    belongs_to :user, Wcsp.User
    has_many :ranks, Wcsp.Rank
    has_many :rank_songs, Wcsp.RankSong, on_replace: :delete
    many_to_many :songs, Wcsp.Song, join_through: Wcsp.Rank

    timestamps()
  end

  @required_fields [:due_date, :status, :user_id]
  @valid_status ~w(creating voting counting published)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(~w(due_date status)a)
    |> validate_inclusion(:status, @valid_status)
    |> unique_constraint(:due_date)
    |> assoc_constraint(:user)
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:due_date])
    |> validate_required([:due_date])
    |> put_change(:status, "creating")
    |> validate_inclusion(:status, ["creating"])
    |> unique_constraint(:due_date)
    |> assoc_constraint(:user)
  end

  def vote_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:due_date])
    |> validate_required([:due_date])
    |> put_change(:status, "creating")
    |> validate_inclusion(:status, ["creating"])
    |> unique_constraint(:due_date)
    |> assoc_constraint(:user)
  end


  @doc """
  Admin sees everything
  """
  def scoped(%User{admin: :true}), do: Top

  @doc """
  Connected user can see voting and published Top + Top he has created
  """
  def scoped(%User{} = user) do
    from m in Top, where: m.user_id == ^user.id or m.status in ["voting", "published"]
  end

  @doc """
  Not connected users see nothing
  """
  def scoped(nil), do: from m in Top, where: false



  def tops() do
    from p in Top, order_by: [desc: p.due_date]
  end

  def top(query, id) do
    from p in query, where: p.id == ^id
  end

  def top(id), do: from p in Top, where: p.id == ^id

end
