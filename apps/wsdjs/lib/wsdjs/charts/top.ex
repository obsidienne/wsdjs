defmodule Wsdjs.Charts.Top do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Wsdjs.{Accounts, Charts, Musics}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tops" do
    field :due_date, :date
    field :status, :string

    belongs_to :user, Accounts.User
    has_many :ranks, Charts.Rank, on_delete: :delete_all
    has_many :votes, Charts.Vote, on_replace: :delete
    many_to_many :songs, Musics.Song, join_through: Charts.Rank

    timestamps()
  end

  @required_fields [:due_date, :status, :user_id]
  @valid_status ~w(checking voting counting published)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(:due_date)
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
  def scoped(%Accounts.User{admin: :true}), do: Charts.Top
  def scoped(%Accounts.User{profil_djvip: true}) do
    from m in Charts.Top, where: m.status in ["voting", "published"]
  end

  # Connected user can see voting and published Top + Top he has created
  def scoped(%Accounts.User{} = user) do
    Charts.Top
    |> where(status: "published")
    |> where([t], t.due_date >= ^Timex.shift(Timex.now, months: -27))
    |> where([t], t.due_date <= ^Timex.shift(Timex.now, months: -3))
  end

  # Not connected users see nothing
  def scoped(nil) do
    Charts.Top
    |> where(status: "published")
    |> where([t], t.due_date >= ^Timex.shift(Timex.now, months: -6))
    |> where([t], t.due_date <= ^Timex.shift(Timex.now, months: -3))
  end
end
