defmodule Wcs.Account do
  use Wcs.Model

  schema "accounts" do
    field :email, :string

    has_many :songs, Dj.Song
    timestamps()
  end

  @allowed_fields [:email]

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:email)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
  end

  def build(%{email: email} = params) do
    changeset(%Wcs.Account{}, params)
  end
end
