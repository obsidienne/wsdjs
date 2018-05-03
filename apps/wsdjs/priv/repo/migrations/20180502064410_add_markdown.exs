defmodule Wsdjs.Repo.Migrations.AddMarkdown do
  use Ecto.Migration

  def change do
    alter table(:comments) do
      add :text_html, :text
    end

    alter table("user_details") do
      add :description_html, :text
    end
  end
end
