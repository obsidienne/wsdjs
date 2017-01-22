defmodule Wcsp.Top do
  use Wcsp.Model

  schema "tops" do
    field :due_date, :date
    field :status, :string

    belongs_to :account, Wcsp.Account
    has_many :ranks, Wcsp.Rank
    timestamps()
  end

  @required_fields [:due_date, :status, :account_id]
  @valid_status ~w(creating voting counting published)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields)
    |> validate_required(~w(due_date status)a)
    |> validate_inclusion(:status, @valid_status)
    |> unique_constraint(:due_date)
    |> assoc_constraint(:account)
  end

  def tops() do
    from p in Top, order_by: [desc: p.due_date]
  end

  def top(query, id) do
    from p in query, where: p.id == ^id
  end

  def top(id), do: from p in Top, where: p.id == ^id

end
