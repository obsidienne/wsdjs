defmodule Wsdjs.Auth.AuthToken do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Auth.AuthToken

  @foreign_key_type :binary_id
  schema "auth_tokens" do
    field :value, :string
    belongs_to :user, Wsdjs.Accounts.User

    timestamps(updated_at: false)
  end

  def changeset(%AuthToken{} = auth_token, attrs) do
    auth_token
    |> cast(attrs, [:user_id, :value])
    |> validate_required([:value, :user_id])
    |> unique_constraint(:value)
    |> assoc_constraint(:user)
  end
end
