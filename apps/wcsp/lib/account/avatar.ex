defmodule Wcsp.Avatar do
  use Wcsp.Model

  schema "avatars" do
    field :cld_id, :string
    field :version, :integer

    belongs_to :user, Wcsp.User
    timestamps()
  end

  @allowed_fields ~w(cld_id version user_id)

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(~w(cld_id version)a)
    |> unique_constraint(:cld_id)
  end
end
