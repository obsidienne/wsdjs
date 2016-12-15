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
    |> validate_format(:email, ~r/.*@.*/)
  end

  def build(params) do
    changeset(%Wcs.Account{}, params)
  end
end
