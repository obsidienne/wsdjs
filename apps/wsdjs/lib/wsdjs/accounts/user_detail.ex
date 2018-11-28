defmodule Wsdjs.Accounts.UserDetail do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Wsdjs.HashID, autogenerate: true}
  @foreign_key_type Wsdjs.HashID
  schema "user_details" do
    field(:description, :string)
    field(:description_html, :string)
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

  def changeset(%__MODULE__{} = user_detail, attrs) do
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
    |> markdown_text(attrs)
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

  defp markdown_text(model, %{"description" => nil}) do
    model
  end

  defp markdown_text(model, %{"description" => body}) do
    {:ok, clean_body, []} = body |> Earmark.as_html()
    clean_body = HtmlSanitizeEx.markdown_html(clean_body)
    model |> put_change(:description_html, clean_body)
  end

  defp markdown_text(model, _) do
    model
  end
end
