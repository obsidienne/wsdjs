defmodule Wsdjs.Repo.Migrations.FulltextIndex do
  use Ecto.Migration

  def change do
    execute """
      CREATE INDEX songs_full_text_index
      ON songs
      USING gin (
        to_tsvector(
          'english',
          artist || ' ' ||
          title
        )
      );
    """
  end
end
