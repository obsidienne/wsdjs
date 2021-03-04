defmodule Wsdjs.Repo do
  use Ecto.Repo,
    otp_app: :wsdjs,
    adapter: Ecto.Adapters.Postgres

  @doc """
  This is used to replace relation with a %Ecto.Association.NotLoaded{} struct.
  You can use it in test to remove cardinality.
  """
  def forget(_, _, cardinality \\ :one)

  def forget(struct, fields, cardinality) when is_list(fields),
    do:
      fields
      |> Enum.reduce(struct, fn field, acc ->
        forget(acc, field, cardinality)
      end)

  def forget(struct, field, cardinality) do
    %{
      struct
      | field => %Ecto.Association.NotLoaded{
          __field__: field,
          __owner__: struct.__struct__,
          __cardinality__: cardinality
        }
    }
  end
end
