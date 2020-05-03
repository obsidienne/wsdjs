defmodule Wsdjs.Charts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Charts.Top
  alias Wsdjs.Repo

  def can?(%User{admin: true}, _), do: :ok
  def can?(%User{profil_djvip: true}, :vote), do: :ok
  def can?(_, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _, %Top{}), do: :ok

  def can?(user, :show, %Top{id: id}) do
    top = Repo.get(Top.scoped(user), id)

    case top do
      %Top{} -> :ok
      nil -> {:error, :unauthorized}
    end
  end

  def can?(_, _, _), do: {:error, :unauthorized}
end
