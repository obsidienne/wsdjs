defmodule Wcsp.Musics.Arts do
  use Wcsp.Schema

  schema "album_arts" do
    field :cld_id, :string
    field :version, :integer

    belongs_to :user, Wcsp.User
    belongs_to :song, Wcsp.Musics.Songs

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
