defmodule User do
  @moduledoc ~S"""
  Contains account business logic of the platform.

  `User` will be used by `rwp_web`, `song` Phoenix apps.
  """
  use Wcsp.Model

  def create_account!(email) do
    Account.build(%{email: email})
    |> Repo.insert!
  end
end
