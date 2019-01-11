defmodule Wsdjs.Attachments.Avatars.Avatar do
  @moduledoc """
  An image used as user avatar.
  """
  use Wsdjs.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer,
          cld_id: String.t(),
          version: integer,
          updated_at: DateTime.t(),
          inserted_at: DateTime.t()
        }

  @allowed_fields ~w(cld_id version user_id)a
  @required_fields ~w(cld_id version)a

  schema "avatars" do
    field(:cld_id, :string)
    field(:version, :integer)

    belongs_to(:user, Wsdjs.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = avatar, attrs) do
    avatar
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:cld_id)
  end
end
