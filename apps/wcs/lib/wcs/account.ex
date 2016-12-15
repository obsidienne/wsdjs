defmodule Wcs.Account do
  use Wcs.Model

  schema "accounts" do
    field :email, :string

    timestamps()
  end

  @allowed_fields ~w(email)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:email)
    |> unique_constraint(:email)
  end
end
