defmodule Wsdjs.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :wsdjs
  use Scrivener, page_size: 50

  @doc """
  Dynamically loads the repository url from the
  POSTGRESQL_ADDON_URI environment variable.
  """
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("POSTGRESQL_ADDON_URI"))}
  end
end
