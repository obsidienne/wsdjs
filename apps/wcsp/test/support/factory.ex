defmodule Wcsp.Factory do
  alias Wcsp.Repo
  use Wcsp.Schema

  # Factories
  def build(:user) do
    %Wcsp.Accounts.User{
      email: "hello#{System.unique_integer()}@dummy.com"
    }
  end

  # Convenience API
  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end

end
