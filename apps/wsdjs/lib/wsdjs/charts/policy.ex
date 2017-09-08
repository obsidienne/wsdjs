defmodule Wsdjs.Charts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Charts.Top

  def can?(:create_top, %User{admin: :true}), do: :ok
  def can?(:delete_top, %User{admin: :true}), do: :ok
  def can?(:stats_top, %User{admin: :true}), do: :ok
  def can?(_, _), do: {:error, :unauthorized}

  def can?(:delete_top, %User{admin: :true}, %Top{} = top), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}
end
