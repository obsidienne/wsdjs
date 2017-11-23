defmodule Wsdjs.Auth.Invitation do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Auth.Invitation

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "invitations" do
    field :email, :string
    field :name, :string
    belongs_to :user, Wsdjs.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Invitation{} = invitation, attrs) do
    invitation
    |> cast(attrs, [:user_id])
  end
end
