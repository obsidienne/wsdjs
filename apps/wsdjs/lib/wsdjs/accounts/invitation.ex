defmodule Wsdjs.Accounts.Invitation do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Accounts.Invitation

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "invitations" do
    field :email, :string
    field :name, :string
    belongs_to :user, Wsdjs.Accounts.User

    timestamps()
  end

  @allowed_fields [:email, :name, :user_id]

  @doc false
  def changeset(%Invitation{} = invitation, attrs) do
    invitation
    |> cast(attrs, @allowed_fields)
    |> validate_required(:email)
    |> validate_required(:name)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/.*@.*/)
  end
end
