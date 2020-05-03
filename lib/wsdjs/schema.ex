defmodule Wsdjs.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:id, Wsdjs.HashID, autogenerate: true}
      @foreign_key_type Wsdjs.HashID
    end
  end
end
