defmodule Wsdjs.Accounts.UserDetail do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Accounts.UserDetail

  @foreign_key_type :binary_id
  schema "user_details" do
    field :description, :string
    field :favorite_genre, :string
    field :favorite_artist, :string
    field :favorite_color, :string
    field :favorite_meal, :string
    field :favorite_animal, :string
    field :djing_start_year, :integer
    field :love_more, :string
    field :hate_more, :string
    field :youtube, :string
    field :facebook, :string
    field :soundcloud, :string

    belongs_to :user, Wsdjs.Accounts.User
    timestamps()
  end

  @allowed_fields [
                    :user_id, :description, :favorite_genre, :favorite_artist, :favorite_color, :favorite_meal,
                    :favorite_animal, :djing_start_year, :love_more, :hate_more, :youtube, :facebook, :soundcloud
                  ]

  def changeset(%UserDetail{} = user_detail, attrs) do
    user_detail
    |> cast(attrs, @allowed_fields)
    |> assoc_constraint(:user)
    |> validate_length(:description, max: 2000)
    |> validate_length(:favorite_genre, max: 2000)
    |> validate_length(:favorite_artist, max: 2000)
    |> validate_length(:favorite_color, max: 2000)
    |> validate_length(:favorite_meal, max: 2000)
    |> validate_length(:love_more, max: 255)
    |> validate_length(:hate_more, max: 255)
    |> validate_number(:djing_start_year, greater_than_or_equal_to: 1950, less_than_or_equal_to: 2017)
  end
end
