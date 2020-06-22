defmodule Wsdjs.HashID do
  @behaviour Ecto.Type
  @hashids Hashids.new(min_len: 8, salt: "ISeeFireByEdSheeranFromTheDesolationOfSmaug")
  @moduledoc """
  Converts integers to Hashids.

  See http://hashids.org/ for more information.
  """

  def type, do: :id

  # TODO: Validate the hashid is valid on cast
  def cast(term) when is_binary(term), do: {:ok, term}
  def cast(_), do: :error

  def dump(term) when is_binary(term) do
    @hashids
    |> Hashids.decode!(term)
    |> case do
      [int] -> {:ok, int}
      _ -> :error
    end
  end

  def dump(_), do: :error

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2

  def load(term) when is_integer(term), do: {:ok, Hashids.encode(@hashids, term)}
  def load(_), do: :error
end
