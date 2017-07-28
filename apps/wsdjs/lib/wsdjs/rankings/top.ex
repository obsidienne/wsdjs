defmodule Wsdjs.Rankings.Top do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Wsdjs.{Accounts, Rankings, Musics}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tops" do
    field :due_date, :date
    field :status, :string

    belongs_to :user, Accounts.User
    has_many :ranks, Rankings.Rank, on_delete: :delete_all
    has_many :votes, Rankings.Vote, on_replace: :delete
    many_to_many :songs, Musics.Song, join_through: Rankings.Rank

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

  def step_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:status])
    |> validate_inclusion(:status, @valid_status)
  end

  # Admin sees everything
  def scoped(%Accounts.User{admin: :true}), do: Rankings.Top

  # Connected user can see voting and published Top + Top he has created
  def scoped(%Accounts.User{} = user) do
    from m in Rankings.Top, where: m.user_id == ^user.id or m.status in ["voting", "published"]
  end

  # Not connected users see nothing
  def scoped(nil), do: from m in Rankings.Top, where: false
end
