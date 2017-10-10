defmodule Release.Tasks do
  def migrate do
    {:ok, _} = Application.ensure_all_started(:wsdjs)

    path = Application.app_dir(:wsdjs, "priv/repo/migrations")

    Ecto.Migrator.run(Wsdjs.Repo, path, :up, all: true)
  end
end