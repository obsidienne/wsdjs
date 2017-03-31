defmodule Wcsp.Musics.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :text, :string

    belongs_to :user, Wcsp.Accounts.User
    belongs_to :song, Wcsp.Musics.Song
    timestamps()
  end

  @allowed_fields [:text, :user_id, :song_id]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @allowed_fields)
    |> validate_required(:text)
    |> validate_length(:text, min: 1)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
  end
end
