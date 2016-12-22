defmodule Wcs do
  @moduledoc ~S"""
  Contains account business logic of the platform.

  `Wcs` will be used by `rwp_web`, `song` Phoenix apps.
  """
  use Wcs.Model

  def create_account!(email) do
    Account.build(%{email: email})
    |> Repo.insert!
  end
end
