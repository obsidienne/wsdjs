defmodule Wcsp.User do
  @moduledoc ~S"""
  Contains account business logic of the platform.

  `User` will be used by `rwp_web`, `song` Phoenix apps.
  """
  alias Wcsp.Repo
  use Wcsp.Model

  def create_account!(email) do
    Account.build(%{email: email})
    |> Repo.insert!
  end

  def accounts do
    Repo.all(Account)
  end

  def find_account!(clauses) do
    Repo.get_by!(Account, clauses)
    |> Repo.preload(:avatar)
  end

  def find_account(clauses) do
    Repo.get_by(Account, clauses)
    |> Repo.preload(:avatar)
  end
end
