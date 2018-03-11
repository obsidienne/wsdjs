defmodule Wsdjs.Happenings.Venue do
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Happenings.Venue

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "venues" do
    field(:name, :string)
    belongs_to(:user, Wsdjs.Accounts.User)

    timestamps()
  end

  @doc false
  def changeset(%Venue{} = venue, attrs) do
    venue
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name])
  end
end
