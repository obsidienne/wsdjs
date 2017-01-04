defmodule Wcsp.Photo do
  use Wcsp.Model

  schema "photos" do
    field :cld_id, :string
    field :version, :integer

    belongs_to :account, User.Account
    belongs_to :song, Dj.Song

    timestamps()
  end

  @allowed_fields ~w(cld_id version)

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(~w(cld_id version)a)
    |> unique_constraint(:cld_id)
  end
end
