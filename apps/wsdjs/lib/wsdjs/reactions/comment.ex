defmodule Wsdjs.Reactions.Comment do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Reactions.Comment

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field(:text, :string)
    field(:text_html, :string)

    belongs_to(:user, Wsdjs.Accounts.User)
    belongs_to(:song, Wsdjs.Musics.Song)
    timestamps()
  end

  @allowed_fields [:text, :user_id, :song_id]

  def changeset(%Comment{} = comment, attrs) do
    comment
    |> cast(attrs, @allowed_fields)
    |> validate_required(:text)
    |> validate_length(:text, min: 1)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
    |> markdown_text(attrs)
  end

  defp markdown_text(model, %{"text" => nil}) do
    model
  end

  defp markdown_text(model, %{"text" => body}) do
    {:ok, clean_body, []} = body |> Earmark.as_html()
    clean_body = HtmlSanitizeEx.markdown_html(clean_body)
    model |> put_change(:text_html, clean_body)
  end

  defp markdown_text(model, _) do
    model
  end
end
