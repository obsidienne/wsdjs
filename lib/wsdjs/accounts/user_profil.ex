defmodule Wsdjs.Accounts.UserProfil do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "users_profils" do
    field(:description, :string)
    field(:description_html, :string)
    field(:favorite_genre, :string)
    field(:favorite_artist, :string)
    field(:djing_start_year, :integer)
    field(:youtube, :string)
    field(:facebook, :string)
    field(:soundcloud, :string)
    field(:website, :string)
    field(:user_country, :string)
    field(:name, :string)
    field(:djname, :string)
    field(:cld_id, :string, default: "wsdjs/missing_avatar.jpg")

    belongs_to(:user, Wsdjs.Accounts.User, type: Wsdjs.HashID)
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
    :website,
    :user_country,
    :name,
    :djname,
    :user_id,
    :cld_id
  ]

  def changeset(%__MODULE__{} = user_profil, attrs) do
    user_profil
    |> cast(attrs, @allowed_fields)
    |> assoc_constraint(:user)
    |> validate_length(:description, max: 2000)
    |> validate_length(:favorite_genre, max: 2000)
    |> validate_length(:favorite_artist, max: 2000)
    |> validate_length(:user_country, max: 2000)
    |> validate_length(:name, max: 2000)
    |> validate_length(:djname, max: 2000)
    |> markdown_text(attrs)
  end

  def update_changeset(%__MODULE__{} = user_profil, attrs) do
    user_profil
    |> cast(attrs, @allowed_fields)
    |> assoc_constraint(:user)
    |> validate_length(:description, max: 2000)
    |> validate_length(:favorite_genre, max: 2000)
    |> validate_length(:favorite_artist, max: 2000)
    |> validate_length(:user_country, max: 2000)
    |> validate_length(:name, max: 2000)
    |> validate_length(:djname, max: 2000)
    |> markdown_text(attrs)
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
