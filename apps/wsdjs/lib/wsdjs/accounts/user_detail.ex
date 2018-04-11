defmodule Wsdjs.Accounts.UserDetail do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Accounts.UserDetail

  @foreign_key_type :binary_id
  schema "user_details" do
    field(:description, :string)
    field(:favorite_genre, :string)
    field(:favorite_artist, :string)
    field(:favorite_color, :string)
    field(:favorite_meal, :string)
    field(:favorite_animal, :string)
    field(:djing_start_year, :integer)
    field(:love_more, :string)
    field(:hate_more, :string)
    field(:youtube, :string)
    field(:facebook, :string)
    field(:soundcloud, :string)
    field(:website, :string)

    belongs_to(:user, Wsdjs.Accounts.User)
    timestamps()
  end

  @allowed_fields [
    :description,
    :favorite_genre,
    :favorite_artist,
    :favorite_color,
    :favorite_meal,
    :favorite_animal,
    :djing_start_year,
    :love_more,
    :hate_more,
    :youtube,
    :facebook,
    :soundcloud,
    :website
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
    |> validate_number(
      :djing_start_year,
      greater_than_or_equal_to: 1950,
      less_than_or_equal_to: 2017
    )
    |> validate_url(:youtube)
    |> validate_url(:facebook)
    |> validate_url(:soundcloud)
    |> validate_url(:website)
  end

  # This function validates the format of an URL not it's validity.
  defp validate_url(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, url ->
      case url |> String.to_charlist() |> :http_uri.parse() do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || "invalid url: #{inspect(msg)}"}]
      end
    end)
  end
end
