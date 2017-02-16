defmodule Wcsp.SongComment do
  use Wcsp.Model

  schema "comments" do
    field :text, :string

    belongs_to :user, Wcsp.User
    belongs_to :song, Wcsp.Song
    timestamps()
  end

  @allowed_fields [:text, :user_id, :song_id]

  def changeset(model, params \\ nil) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(:text)
    |> assoc_constraint(:user)
    |> assoc_constraint(:song)
  end
end
