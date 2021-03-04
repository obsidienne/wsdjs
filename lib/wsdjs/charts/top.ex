defmodule Brididi.Charts.Top do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Brididi.{Accounts, Charts}

  @allowed_fields ~w(due_date user_id)a
  @valid_status ~w(checking voting counting published)

  @primary_key {:id, Brididi.HashID, autogenerate: true}
  schema "tops" do
    field(:due_date, :date)
    field(:status, :string)

    belongs_to(:user, Brididi.Accounts.User, type: Brididi.HashID)
    has_many(:ranks, Brididi.Charts.Rank, on_delete: :delete_all)
    has_many(:votes, Brididi.Charts.Vote, on_replace: :delete)
    many_to_many(:songs, Brididi.Musics.Song, join_through: Charts.Rank)

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

  def scoped(%Accounts.User{profil_dj: true}), do: scoped(-24, -3)

  # Connected user can see voting and published Top + Top he has created
  def scoped(%Accounts.User{}), do: scoped(-12, -3)
  def scoped(nil), do: scoped(-5, -3)

  defp scoped(lower, upper) when is_integer(lower) and is_integer(upper) do
    {:ok, current_month} =
      Date.utc_today()
      |> Date.beginning_of_month()
      |> DateTime.new(~T[00:00:00])

    from t in Charts.Top,
      where:
        t.status == "published" and
          t.due_date >= datetime_add(^current_month, ^lower, "month") and
          t.due_date <= datetime_add(^current_month, ^upper, "month")
  end
end
