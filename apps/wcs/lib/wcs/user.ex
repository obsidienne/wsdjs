defmodule Wcs.User do
  use Wcs.Model

  schema "users" do
    field :email, :string
  end

  @required_fields ~w(email)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields)
  end
end
