defmodule Wsdjs.Repo.Migrations.ConvertMarkdown do
  use Ecto.Migration
  import Ecto.Query

  def change do
    Wsdjs.Repo.all(Wsdjs.Reactions.Comments.Comment)
    |> Enum.map(fn c ->
      text_html =
        c.text
        |> Earmark.as_html!()
        |> HtmlSanitizeEx.markdown_html()

      c
      |> Ecto.Changeset.cast(%{text_html: text_html}, [:text_html])
      |> Wsdjs.Repo.update()
    end)

    Wsdjs.Accounts.UserDetail
    |> where([u], not is_nil(u.description))
    |> Wsdjs.Repo.all()
    |> Enum.map(fn c ->
      description_html =
        c.description
        |> Earmark.as_html!()
        |> HtmlSanitizeEx.markdown_html()

      Ecto.Changeset.cast(c, %{description_html: description_html}, [:description_html])
      |> Wsdjs.Repo.update()
    end)
  end
end
