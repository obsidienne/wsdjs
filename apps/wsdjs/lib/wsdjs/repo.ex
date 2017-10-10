defmodule Wsdjs.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :wsdjs
  use Scrivener, page_size: 50

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  POSTGRESQL_ADDON_URI is used by clever-cloud
  """
  def init(_, opts) do
    url = System.get_env("POSTGRESQL_ADDON_URI") || raise "expected the POSTGRESQL_ADDON_URI environment variable to be set (postgresql://user:password@host:5432/database)"

    {:ok, Keyword.put(opts, :url, url)}
  end
end
