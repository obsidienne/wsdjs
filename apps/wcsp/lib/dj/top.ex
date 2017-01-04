defmodule Wcsp.Top do
  use Wcsp.Model

  schema "tops" do
    field :due_date, Ecto.Date
    field :status, :string

    belongs_to :account, User.Account

    timestamps()
  end

  @required_fields [:due_date, :status]

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields)
    |> validate_required(~w(due_date status)a)
    |> unique_constraint(:due_date)
    |> assoc_constraint(:account)
  end
end
