defmodule Wcsp do
  @moduledoc ~S"""
  Contains main business logic of the project.

  `Wcsp` is used by `wsdjs` Phoenix app.
  """
  use Wcsp.Schema

  def find_user!(clauses) do
    User
    |> User.with_avatar()
    |> Repo.get_by!(clauses)
  end

  def find_user(clauses) do
    User
    |> User.with_avatar()
    |> Repo.get_by(clauses)
  end

  def find_user_with_songs(current_user, clauses) do
    User.scoped(current_user)
    |> User.with_avatar()
    |> User.with_songs(current_user)
    |> Repo.get_by(clauses)
  end

end
