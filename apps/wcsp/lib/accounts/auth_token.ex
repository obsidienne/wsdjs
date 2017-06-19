defmodule Wcsp.Accounts.AuthToken do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.AuthToken

  @foreign_key_type :binary_id
  schema "auth_tokens" do
    field :value, :string
    belongs_to :user, Wcsp.Accounts.User

    timestamps(updated_at: false)
  end

  def changeset(struct, user) do
    struct
    |> cast(%{}, [])
    |> put_assoc(:user, user)
    |> put_change(:value, generate_token(user))
    |> validate_required([:value, :user])
    |> unique_constraint(:value)
  end

  # generate a random and url-encoded token of given length
  defp generate_token(nil), do: nil
  defp generate_token(user) do
    Token.sign(Endpoint, "user", user.id)
  end
end
