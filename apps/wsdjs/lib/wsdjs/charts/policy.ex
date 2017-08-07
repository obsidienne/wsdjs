defmodule Wsdjs.Charts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User

  @doc """
  Admin can create a top
  """
  def can?(:create_top, %User{admin: :true}), do: :ok

  @doc """
  Admin can delete a top
  """
  def can?(:delete_top, %User{admin: :true}), do: :ok

  @doc """
  By default everything is denied
  """
  def can?(_, _), do: {:error, :unauthorized}
end
