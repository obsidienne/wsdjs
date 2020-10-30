defmodule Wsdjs.Charts.Top do
  @moduledoc false
  use Wsdjs.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Wsdjs.{Accounts, Charts, Songs}

  @type t :: %__MODULE__{
          id: integer,
          due_date: Date.t(),
          status: String.t(),
          updated_at: DateTime.t(),
          inserted_at: DateTime.t()
        }

  @allowed_fields ~w(due_date user_id)a
  @valid_status ~w(checking voting counting published)

  schema "tops" do
    field(:due_date, :date)
    field(:status, :string)

    belongs_to(:user, Accounts.User)
    has_many(:ranks, Charts.Rank, on_delete: :delete_all)
    has_many(:votes, Charts.Vote, on_replace: :delete)
    many_to_many(:songs, Songs.Song, join_through: Charts.Rank)

    timestamps()
  end

  def create_changeset(%__MODULE__{} = top, attrs) do
    top
    |> cast(attrs, @allowed_fields)
    |> validate_required(:due_date)
    |> change(status: "checking")
    |> validate_inclusion(:status, @valid_status)
    |> unique_constraint(:due_date)
    |> assoc_constraint(:user)
  end

  def step_changeset(%__MODULE__{} = top, attrs) do
    top
    |> cast(attrs, [:status])
    |> validate_inclusion(:status, @valid_status)
  end

  # Admin sees everything
  def scoped(%Accounts.User{admin: true}), do: Charts.Top

  def scoped(%Accounts.User{profil_djvip: true}) do
    from(m in Charts.Top, where: m.status in ["voting", "published"])
  end

  def scoped(%Accounts.User{profil_dj: true}) do
    from(m in Charts.Top, where: m.status in ["published"])
  end

  def scoped(%Accounts.User{}) do
    Charts.Top
    |> where(status: "published")
    |> offset(3)
    |> limit(12)
  end

  def scoped(nil) do
    Charts.Top
    |> where(status: "published")
    |> offset(3)
    |> limit(3)
  end
end
