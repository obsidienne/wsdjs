defmodule Wsdjs.Charts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Charts.Top

  def can?(%User{admin: :true}, :create_top), do: :ok
  def can?(%User{admin: :true}, :delete_top), do: :ok
  def can?(%User{admin: :true}, :stats_top), do: :ok
  def can?(_, _), do: {:error, :unauthorized}

  def can?(%User{admin: :true}, :delete_top, %Top{}), do: :ok
  def can?(%User{admin: :true}, :update_top, %Top{}), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}
end
