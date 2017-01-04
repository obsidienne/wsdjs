defmodule Wcsp.Account do
  use Wcsp.Model

  schema "accounts" do
    field :email, :string
    field :admin, :boolean
    field :new_song_notification
    field :user_country, :string
    field :last_name, :string
    field :first_name, :string
    field :djname, :string

    has_many :songs, Wcsp.Song
    timestamps()
  end

  @allowed_fields [:email, :new_song_notification, :user_country, :last_name, :first_name, :djname]

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:email)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
  end

  def build(%{email: email} = params) do
    changeset(%Wcsp.Account{}, params)
  end
end
