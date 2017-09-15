defmodule Wsdjs.Charts.Policy do
  @moduledoc """
  The Policies for the Dj system.
  """
  alias Wsdjs.Accounts.User
  alias Wsdjs.Charts.Top

  def can?(%User{admin: :true}, _), do: :ok
  def can?(_, _), do: {:error, :unauthorized}

  def can?(%User{admin: :true}, _, %Top{}), do: :ok
  def can?(nil, :show, %Top{status: "published"} = top), do: :ok
  def can?(_, _, _), do: {:error, :unauthorized}
end
