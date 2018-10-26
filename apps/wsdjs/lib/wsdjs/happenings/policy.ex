defmodule Wsdjs.Happenings.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User

  def can?(%User{admin: true}, _), do: :ok
  def can?(_, _), do: {:error, :unauthorized}

  def can?(%User{admin: true}, _, _), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}
end
