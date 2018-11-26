defmodule Wsdjs.Musics.Art do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset
  alias Wsdjs.Musics.Art

  @primary_key {:id, Wsdjs.HashID, autogenerate: true}
  @foreign_key_type Wsdjs.HashID
  schema "arts" do
    field(:cld_id, :string)
    field(:version, :integer)

    belongs_to(:song, Wsdjs.Musics.Song)

    timestamps()
  end

  @allowed_fields [:cld_id, :version]

  def changeset(%Art{} = art, attrs) do
    art
    |> cast(attrs, @allowed_fields)
    |> validate_required(~w(cld_id version)a)
    |> unique_constraint(:cld_id)
  end
end
