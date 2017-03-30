defmodule Wcsp.Musics.Art do
  use Wcsp.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "album_arts" do
    field :cld_id, :string
    field :version, :integer

    belongs_to :user, Wcsp.Accounts.User
    belongs_to :song, Wcsp.Musics.Song

    timestamps()
  end

  @allowed_fields [:cld_id, :version]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(~w(cld_id version)a)
    |> unique_constraint(:cld_id)
  end
end
