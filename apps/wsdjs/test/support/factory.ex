defmodule Wsdjs.Factory do
  # Factories
  def build(:user) do
    %Wsdjs.Accounts.User{
      email: "hello#{System.unique_integer()}@dummy.com"
    }
  end

  # Convenience API
  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Wsdjs.Repo.insert! build(factory_name, attributes)
  end

end
