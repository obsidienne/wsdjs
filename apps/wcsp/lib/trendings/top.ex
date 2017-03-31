defmodule Wcsp.Trendings.Top do
  use Wcsp.Schema

  alias Wcsp.Accounts
  alias Wcsp.Trendings
  alias Wcsp.Musics

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tops" do
    field :due_date, :date
    field :status, :string

    belongs_to :user, Accounts.User
    has_many :ranks, Trendings.Rank
    has_many :rank_songs, Trendings.Vote, on_replace: :delete
    many_to_many :songs, Musics.Song, join_through: Trendings.Rank

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
  def scoped(%Accounts.User{admin: :true}), do: Trendings.Top

  @doc """
  Connected user can see voting and published Top + Top he has created
  """
  def scoped(%Accounts.User{} = user) do
    from m in Trendings.Top, where: m.user_id == ^user.id or m.status in ["voting", "published"]
  end

  @doc """
  Not connected users see nothing
  """
  def scoped(nil), do: from m in Trendings.Top, where: false



  def tops() do
    from p in Trendings.Top, order_by: [desc: p.due_date]
  end

  def top(query, id) do
    from p in query, where: p.id == ^id
  end

  def top(id), do: from p in Trendings.Top, where: p.id == ^id

end
