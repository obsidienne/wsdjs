defmodule Photo.Photo do
  use Photo.Model

  schema "photos" do
    field :cld_id, :string
    field :version, :integer

    belongs_to :user, Wcs.User
  end

  @required_fields ~w(cld_id version)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields)
    |> validate_required(~w(cld_id version)a)
    |> unique_constraint(:cld_id)
  end
end
