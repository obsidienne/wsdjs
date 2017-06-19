defmodule Wcsp.Accounts.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wcsp.Accounts.AuthToken

  @foreign_key_type :binary_id
  schema "auth_tokens" do
    field :value, :string
    belongs_to :user, Wcsp.Accounts.User

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
