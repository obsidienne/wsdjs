defmodule Wsdjs.Accounts.Avatar do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Accounts.Avatar

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "avatars" do
    field(:cld_id, :string)
    field(:version, :integer)

    belongs_to(:user, Wsdjs.Accounts.User)
    timestamps()
  end

  @allowed_fields [:cld_id, :version, :user_id]

  def changeset(%Avatar{} = avatar, attrs) do
    avatar
    |> cast(attrs, @allowed_fields)
    |> validate_required([:cld_id, :version])
    |> unique_constraint(:cld_id)
  end
end
