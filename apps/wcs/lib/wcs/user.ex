defmodule Wcs.User do
  use Wcs.Model

  schema "users" do
    field :email, :string
  end

  @allowed_fields ~w(email)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:email)
    |> unique_constraint(:email)
  end
end
