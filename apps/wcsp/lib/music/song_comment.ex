defmodule Wcsp.SongComment do
  use Wcsp.Schema

  schema "comments" do
    field :text, :string

    belongs_to :user, Wcsp.User
    belongs_to :song, Wcsp.Song
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
