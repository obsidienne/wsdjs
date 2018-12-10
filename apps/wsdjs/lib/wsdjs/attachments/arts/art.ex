defmodule Wsdjs.Attachments.Arts.Art do
  @moduledoc """
  An image used as song art.
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

  @allowed_fields ~w(cld_id version)a
  @required_fields ~w(cld_id version)a

  schema "arts" do
    field(:cld_id, :string)
    field(:version, :integer)

    belongs_to(:song, Wsdjs.Musics.Song)

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = art, attrs) do
    art
    |> cast(attrs, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:cld_id)
  end
end
