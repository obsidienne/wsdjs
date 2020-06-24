defmodule Wsdjs.Accounts.Profil do
  @moduledoc false
  use Wsdjs.Schema
  import Ecto.Changeset

  schema "profils" do
    field(:description, :string)
    field(:description_html, :string)
    field(:favorite_genre, :string)
    field(:favorite_artist, :string)
    field(:djing_start_year, :integer)
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
    :djing_start_year,
    :youtube,
    :facebook,
    :soundcloud,
    :website
  ]

  def changeset(%__MODULE__{} = profil, attrs) do
    profil
    |> cast(attrs, @allowed_fields)
    |> assoc_constraint(:user)
    |> validate_length(:description, max: 2000)
    |> validate_length(:favorite_genre, max: 2000)
    |> validate_length(:favorite_artist, max: 2000)
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
