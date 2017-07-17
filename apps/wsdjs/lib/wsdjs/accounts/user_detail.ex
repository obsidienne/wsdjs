defmodule Wsdjs.Accounts.UserDetail do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @foreign_key_type :binary_id
  schema "user_details" do
    field :description, :string
    field :favorite_genre, :string
    field :favorite_artist, :string
    field :favorite_color, :string
    field :favorite_meal, :string
    field :favorite_animal, :string
    field :djing_start_year, :integer
    field :tastes, :string

    belongs_to :user, Wsdjs.Accounts.User
    timestamps()
  end

  @allowed_fields [:user_id, :description, :favorite_genre, :favorite_artist, :favorite_color, :favorite_meal, :favorite_animal, :djing_start_year, :tastes]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> assoc_constraint(:user)
    |> validate_length(:description, max: 2000)
    |> validate_length(:favorite_genre, max: 2000)
    |> validate_length(:favorite_artist, max: 2000)
    |> validate_length(:favorite_color, max: 2000)
    |> validate_length(:favorite_meal, max: 2000)
    |> validate_length(:tastes, max: 2000)
    |> validate_number(:djing_start_year, greater_than: 1950, less_than: 2017)
  end
end
