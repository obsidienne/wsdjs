defmodule Wcsp.Trendings.Top do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Wcsp.{Accounts, Trendings, Musics}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "trendings_tops" do
    field :due_date, :date
    field :status, :string

    belongs_to :user, Accounts.User
    has_many :ranks, Trendings.Rank
    has_many :votes, Trendings.Vote, on_replace: :delete
    many_to_many :songs, Musics.Song, join_through: Trendings.Rank

    timestamps()
  end

  @required_fields [:due_date, :status, :user_id]
  @valid_status ~w(checking voting counting published)

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
    |> put_change(:status, "checking")
    |> validate_inclusion(:status, ["checking"])
    |> unique_constraint(:due_date)
    |> assoc_constraint(:user)
  end

  def next_step_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
    |> validate_inclusion(:status, @valid_status)
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
end
