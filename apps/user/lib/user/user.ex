defmodule User.User do
  use User.Model, :model

  schema "users" do
    field :email, :string
  end

  @required_fields ~w(email)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields)
  end
end
